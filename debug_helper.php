<?php
/*
 * デバッグヘルパー
 * ウォッチ式やデバッグコンソールで使用する想定
 */

if (!function_exists('sd')) {
    // CP932をUTF-8に変換
    function sd($var) {
        $str = print_r($var, true);
        return mb_convert_encoding($str, 'UTF-8', 'CP932');
    }
}
