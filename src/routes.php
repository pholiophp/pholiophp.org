<?php

use DominionEnterprises\Util;

$app->get('/', function ($request, $response) {
    return $this->renderer->render($response, 'index.html', ['title' => 'Pholio - The PHP Document Archive', 'is_front' => true]);
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

    $menuXsl = new DOMDocument();
    $menuXsl->load(__DIR__ . '/../menu.xsl');
    $menuXslProcessor = new XSLTProcessor();
    $menuXslProcessor->registerPHPFunctions();
    $menuXslProcessor->importStyleSheet($menuXsl);

    return $this->renderer->render(
        $response,
        'library.html',
        $document->getArrayCopy() + [
			'menu' => $menuXslProcessor->transformToXML($xmlDoc),
			'phpdoc' => $this->xsltProcessor->transformToXML($xmlDoc),
        ]
    );
});

$app->post('/search', function ($request, $response, $arguments) {
    $result = ['libraries' => []];
    try {
        $keywords = Util\Arrays::get($request->getParsedBody(), 'keywords');
        $keywords = preg_replace("/[^A-Za-z0-9 ]/", '', $keywords); //remove non-alphanumeric
        $keywords = strtolower($keywords);
        $keywords = preg_replace('/[^\x20-\x7E]/', ' ', $keywords); // remove non ASCII
        $keywords = preg_replace('/\s+/', ' ', $keywords); // remove superfluous whitespace
        $keywords = trim($keywords);

        if (trim($keywords) != '') {
            $ors = [];
            foreach (explode(' ', $keywords) as $keyword) {
                $ors[] = ['keywords' => ['$regex' => "^{$keyword}"]];
                $ors[] = ['owner' => ['$regex' => "^{$keyword}"]];
                $ors[] = ['package' => ['$regex' => "^{$keyword}"]];
            }

            $libraries = $this->mongodb->selectCollection('libraries')->find(
                ['$or' => $ors],
                [
                    'projection' => [
                        'owner' => true,
                        'package' => true,
                        'description' => true,
                        'stars' => true,
                        'watchers' => true,
                    ],
                    'sort' => ['owner' => 1, 'package' => 1, 'keywords' => 1],
                ]
            )->toArray();

            $result = ['libraries' => $libraries];
        }
    } catch (Throwable $e) {
        $result = ['libraries' => []];
    }

    $stream = fopen('php://temp', 'r+');
    fwrite($stream, json_encode($result));
    rewind($stream);

    return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->withBody(
		new Zend\Diactoros\Stream($stream)
    );
});

$app->get('/{username}', function ($request, $response, $arguments) {
    $username = Util\Arrays::get($arguments, 'username');
    $libraries = $this->mongodb->selectCollection('libraries')->find(
        ['owner' => $username],
        [
            'projection' => [
                'owner' => true,
                'package' => true,
                'description' => true,
                'avatar' => true,
                'stars' => true,
                'watchers' => true,
            ],
            'sort' => ['package' => 1],
        ]
    )->toArray();

    $avatar = 'https://avatars2.githubusercontent.com/u/14337786';
    if (!empty($libraries)) {
        $avatar = $libraries[0]['avatar'];
    }

    return $this->renderer->render(
        $response,
        'user.html',
        ['libraries' => $libraries, 'owner' => $username, 'avatar' => $avatar]
    );
});

