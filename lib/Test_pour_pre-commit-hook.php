<?php

class testClass
{
    public function testFunction()
    {
        $unused = 42; // Variable utilisée (non détectée par PHP MD)

        echo "toto"; // Erreur MD détectée
    }
}
