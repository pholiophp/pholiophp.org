<?php

use DominionEnterprises\Util;

$app->get('/', function ($request, $response) {
    $count = $this->mongodb->selectCollection('libraries')->count([]);

    $keywords = $this->mongodb->selectCollection('keywords')->find(
        [],
        [
            'projection' => ['count' => true, '_id' => true],
            'sort' => ['count' => -1],
            'limit' => 10,
        ]
    )->toArray();

    $owners = $this->mongodb->selectCollection('owners')->find(
        [],
        [
            'projection' => ['count' => true, '_id' => true],
            'sort' => ['count' => -1],
            'limit' => 10,
        ]
    )->toArray();

    return $this->renderer->render(
        $response,
        'pages/index.html',
        [
            'title'    => 'Pholio - The PHP Document Archive',
            'is_front' => true,
            'count' => $count,
            'keywords' => array_combine(array_column($keywords, '_id'), array_column($keywords, 'count')),
            'owners' => array_combine(array_column($owners, '_id'), array_column($owners, 'count')),
            'query' => Util\Arrays::get($request->getQueryParams(), 'q'),
        ]
    );
});

$app->get('/{username}/{repos}[/{version}]', function ($request, $response, $arguments) {
    $owner    = Util\Arrays::get($arguments, 'username');
    $library  = Util\Arrays::get($arguments, 'repos');
    $version  = Util\Arrays::get($arguments, 'version', 'dev-master');
    $id       = "{$owner}-{$library}";
    $document = $this->mongodb->selectCollection('libraries')->findOne(['_id' => $id]);
    if ($document === null) {
        return $response->withRedirect("/{$owner}");
    }

    $xmlDoc = new \DOMDocument();
    $xmlDoc->loadXml($document[$version]);

    $menuXsl = new DOMDocument();
    $menuXsl->load(__DIR__ . '/../menu.xsl');
    $menuXslProcessor = new XSLTProcessor();
    $menuXslProcessor->registerPHPFunctions();
    $menuXslProcessor->importStyleSheet($menuXsl);

    return $this->renderer->render(
        $response,
        'pages/library.html',
        $document->getArrayCopy() + [
            'menu'   => $menuXslProcessor->transformToXML($xmlDoc),
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
            $ands = [];
            foreach (explode(' ', $keywords) as $keyword) {
                $ands[] = [
                    '$or' => [
                        ['keywords' => ['$regex' => "^{$keyword}"]],
                        ['owner' => ['$regex' => "^{$keyword}"]],
                        ['package' => ['$regex' => "^{$keyword}"]],
                    ]
                ];
            }

            $libraries = $this->mongodb->selectCollection('libraries')->find(
                ['$and' => $ands],
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

    $response->getBody()->rewind();
    $response->getBody()->write(json_encode($result));

    return $response->withStatus(200)->withHeader('Content-Type', 'application/json');
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
        'pages/user.html',
        ['libraries' => $libraries, 'owner' => $username, 'avatar' => $avatar]
    );
});
