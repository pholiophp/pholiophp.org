<?php

use Pholio\Controllers\HomeController;

// DIC configuration
$container = $app->getContainer();

// view renderer
$container['renderer'] = function ($c) {
    $settings = $c->get('settings')['renderer'];
    return new Slim\Views\Twig($settings['template_path']);
};

$container['mongodb'] = function ($c) {
    $settings = $c->get('settings')['mongodb'];
    return (new \MongoDB\Client($settings['server']))->selectDatabase($settings['database']);
};

$container['xsltProcessor'] = function ($c) {
    $document = new DOMDocument();
    $document->load(__DIR__ . '/../structure.xsl');
    $xsltProcessor = new XSLTProcessor();
    $xsltProcessor->registerPHPFunctions();
    $xsltProcessor->importStyleSheet($document);
    return $xsltProcessor;
};

$container[HomeController::class] = function ($c) {
    return new HomeController(
        $c->get('renderer'),
        $c->get('mongodb')->selectCollection('libraries')
    );
};
