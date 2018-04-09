<?php

namespace PholioTest\Controllers;

use MongoDB\Client;
use MongoDB\Collection;
use Pholio\Controllers\HomeController;
use PHPUnit\Framework\TestCase;
use Slim\Views\Twig;
use Zend\Diactoros\Response;
use Zend\Diactoros\ServerRequest;
use Zend\Diactoros\Uri;

/**
 * @coversDefaultClass \Pholio\Controllers\HomeController
 * @covers ::<private>
 * @covers ::__construct
 */
final class HomeControllerTest extends TestCase
{
    /**
     * @var Twig
     */
    private $view;

    /**
     * @var Collection
     */
    private $collection;

    public function setUp()
    {
        $this->view = $this->getView();
        $this->collection = $this->getCollection();
        $this->collection->deleteMany([]);
    }

    /**
     * @test
     * @covers ::index
     *
     * @return void
     */
    public function index()
    {
        $library = $this->insertLibrary();
        $controller = new HomeController($this->view, $this->collection);
        $responseBody = (string)$controller->index(new ServerRequest(), new Response())->getBody();
        $this->assertContains('Libraries by keyword', $responseBody);
        $this->assertContains('Libraries by organization', $responseBody);
    }

    private function getView() : Twig
    {
        return new Twig(__DIR__ . '/../../templates');
    }

    private function getCollection() : Collection
    {
        return (new Client())->selectDatabase('testing')->selectCollection('libraries');
    }

    private function insertLibrary(array $library = []) : array
    {
        $library += [
            '_id' => 'unit-test-phplib',
            'owner' => 'unit-test',
            'package' => 'phplib',
            'repository' => 'http://github.com/unit-test/phplib',
            'source' => 'http://example.com',
            'stars' => 1,
            'watchers' => 1,
            'forks' => 0,
            'issues' => 0,
            'avatar' => 'http://example.com/image.jpg',
            'keywords' => ['php', 'unit', 'test'],
            'description' => 'a description',
            'tags' => ['dev-master', 'v1', 'v2'],
        ];

        $this->collection->insertOne($library);

        return $library;
    }
}
