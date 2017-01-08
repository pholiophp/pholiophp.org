<?php

use DominionEnterprises\Util;

$app->get('/', function ($request, $response) {
    return $this->renderer->render($response, 'index.html', ['title' => 'Pholio - The PHP Document Archive']);
});

$app->post('/hook', function ($request, $response, $arguments) {
    try {
        $signature = Util::ensureNot(
            '',
            $request->getHeaderLine('X-Hub-Signature'),
            __NAMESPACE__ . '\\Exception',
            ['No signature provided', 400]
        );

        $event = Util::ensureNot(
            '',
            $request->getHeaderLine('X-GitHub-Event'),
            __NAMESPACE__ . '\\Exception',
            ['No event provided', 400]
        );

        list($algorithm, $hash) = explode('=', $signature) + [1 => null];
        Util::ensure(
            $hash,
            hash_hmac($algorithm, (string)$response->getBody(), $this->githubHookSecret),
            '\\Exception',
            ['Invalid signature provided', 400]
        );

        $payload = json_decode((string)$response->getBody(), true);
        Util::ensure(
            JSON_ERROR_NONE,
            json_last_error(),
            '\\Exception',
            [json_last_error_msg(), 400]
        );

        $this->queue->send(['event' => $event, 'payload' => $payload]);
    } catch (Exception $e) {
        return $e->formatResponse($response);
    } catch (Throwable $e) {
        return Exception::fromThrowable($e, 500)->formatResponse($response);
    }

    return $response->withStatus(202);
});

$app->get('/{username}/{repos}[/{version}]', function ($request, $response, $arguments) {

    $owner = Util\Arrays::get($arguments, 'username');
    $library = Util\Arrays::get($arguments, 'repos');
    $version = Util\Arrays::get($arguments, 'version', 'dev-master');

    $id = "{$owner}-{$library}";

    $document = Util::ensureNot(
        null,
        $this->mongodb->selectCollection('libraries')->findOne(['_id' => $id]),
        'http',
        ["Repository {$owner}/{$library} not found", 404]
    );

    $xmlDoc = new \DOMDocument();
    $xmlDoc->loadXml($document[$version]);

    return $this->renderer->render(
        $response,
        'library.html',
        $document->getArrayCopy() + ['phpdoc' => $this->xsltProcessor->transformToXML($xmlDoc)]
    );
});

$app->get('/{username}', function ($request, $response, $arguments) {
    $username = Util\Arrays::get($arguments, 'username');
    $libraries = $this->mongodb->selectCollection('libraries')->find(
        ['owner' => $username],
        ['projection' => ['owner' => true, 'package' => true, 'description' => true]]
    )->toArray();

    return $this->renderer->render($response, 'user.html', ['libraries' => $libraries, 'owner' => $username]);
});

