<?php

namespace Pholio\Util;

abstract class Xslt
{
    public static function signature(array $arguments)
    {
        $node = $arguments[0];

        $xpath = new \DOMXPath($node->ownerDocument);
        $methodName = $xpath->query('name', $node)->item(0)->nodeValue;
        $parameters = [];
        foreach ($xpath->query('argument', $node) as $argument) {
            $byReference = $argument->getAttribute('by_reference') === 'true' ? ' &' : ' ';
            $type = $xpath->query('type', $argument)->item(0)->nodeValue;
            $name = $xpath->query('name', $argument)->item(0)->nodeValue;
            $default = $xpath->query('default', $argument)->item(0)->nodeValue;
            if (trim($default) !== '') {
                $default = " = {$default}";
            }

            $parameters[] = "{$type}{$byReference}{$name}{$default}";
        }

        $returnTags = $xpath->query("docblock/tag[@name='return']/type", $node);
        $return = $returnTags->length ? $returnTags->item(0)->nodeValue : 'void';

        $signature = "{$methodName}(" . implode(', ', $parameters) . ") : {$return}";
        if (strlen($signature) <= 80) {
            return $signature;
        }

        return "{$methodName}(\n  " . implode(",\n  ", $parameters) . "\n) : {$return}";

    }

    public static function decode(array $arguments)
    {
        $node = array_pop($arguments);
        $input = $node->nodeValue;
        $decodeOnce = html_entity_decode($input);
        $decodeTwice = html_entity_decode($decodeOnce);
        if ($decodeTwice !== $decodeOnce) {
            return null;
        }

        return $decodeOnce;
    }

    public static function stripTags(array $arguments)
    {
        $node = array_pop($arguments);
        $input = $node->nodeValue;
        $decodeOnce = html_entity_decode($input);
        $decodeTwice = html_entity_decode($decodeOnce);
        if ($decodeTwice !== $decodeOnce) {
            return null;
        }

        return strip_tags($decodeOnce);
    }
}
