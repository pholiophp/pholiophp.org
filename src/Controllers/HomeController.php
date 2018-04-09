<?php

namespace Pholio\Controllers;

use DominionEnterprises\Util\Arrays;
use MongoDB\Collection;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\ResponseInterface;
use Slim\Views\Twig;

/**
 * Controller for requests to /.
 */
final class HomeController
{
    /**
     * @var Twig
     */
    private $view;

    /**
     * @var Collection
     */
    private $collection;

    /**
     * Construct a new instance of HomeController.
     *
     * @param Twig       $view       A configured Twig templating instance.
     * @param Collection $collection Mongo collection containing library information.
     */
    public function __construct(Twig $view, Collection $collection)
    {
        $this->view = $view;
        $this->collection = $collection;
    }

    /**
     * Handle GET / requests.
     *
     * @param ServerRequestInterface $request   Represents the current HTTP request.
     * @param ResponseInterface      $response  Represents the current HTTP response.
     * @param array                  $arguments Values for the current route’s named placeholders.
     *
     * @return ResponseInterface
     */
    public function index(ServerRequestInterface $request, ResponseInterface $response, array $arguments = [])
    {
        return $this->view->render(
            $response,
            'pages/index.html',
            [
                'title'    => 'Pholio - The PHP Document Archive',
                'is_front' => true,
                'count' => $this->collection->count([]),
                'query' => Arrays::get($request->getQueryParams(), 'q'),
            ]
        );
    }
}
