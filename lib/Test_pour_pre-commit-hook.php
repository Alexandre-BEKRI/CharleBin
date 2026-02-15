<?php
class testClass
{
    public function testFunction( )
    {
        $unused = 42; // Variable non utilisée (détectée par PHP MD)
        echo "Hello world\n";
    }
}