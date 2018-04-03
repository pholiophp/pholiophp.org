<?php

namespace Pholio\Controllers;

use DominionEnterprises\Util\Arrays;
use MongoDB\Collection;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\ResponseInterface;
use Slim\Views\Twig;
use Throwable;

final class SearchController
{
    /**
     * @var Collection
     */
    private $collection;

    public function __construct(Collection $collection)
    {
        $this->collection = $collection;
    }

    /**
     * Handle POST /search requests.
     *
     * @param ServerRequestInterface $request  The current HTTP request.
     * @param ResponseInterface      $response The current HTTP response.
     *
     * @return ResponseInterface
     */
    public function post(ServerRequestInterface $request, ResponseInterface $response)
    {
        $keywords = $this->getFilteredKeywords(Arrays::get($request->getParsedBody(), 'keywords'));
        if (empty($keywords)) {
            return $this->getJsonResponse($response, []);
        }

        try {
            $ands = [];
            foreach ($keywords as $keyword) {
                $ands[] = [
                    '$or' => [
                        ['keywords' => ['$regex' => "^{$keyword}"]],
                        ['owner' => ['$regex' => "^{$keyword}"]],
                        ['package' => ['$regex' => "^{$keyword}"]],
                    ]
                ];
            }

            $libraries = $this->collection->find(
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
            );

            return $this->getJsonResponse($response, $libraries->toArray());
        } catch (Throwable $e) {
            return $this->getJsonResponse($response, []);
        }
    }

    private function getFilteredKeywords(string $keywords = null) : array
    {
        if ($keywords === null) {
            return [];
        }

        $keywords = preg_replace("/[^A-Za-z0-9 ]/", '', $keywords); //remove non-alphanumeric
        $keywords = strtolower($keywords);
        $keywords = preg_replace('/[^\x20-\x7E]/', ' ', $keywords); // remove non ASCII
        $keywords = preg_replace('/\s+/', ' ', $keywords); // remove superfluous whitespace
        $keywords = trim($keywords);
        return array_filter(explode(' ', $keywords));
    }

    private function getJsonResponse(ResponseInterface $response, array $libraries = []) : ResponseInterface
    {
        $response->getBody()->rewind();
        $response->getBody()->write(json_encode(['libraries' => $libraries]));
        return $response->withStatus(200)->withHeader('Content-Type', 'application/json');
    }
}
