<?php

use DominionEnterprises\Util;

$app->get('/', 'Pholio\\Controllers\\HomeController:index');
$app->post('/search', 'Pholio\\Controllers\\SearchController:post');

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
