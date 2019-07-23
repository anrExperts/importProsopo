let $text := file:read-text('/Users/emmanuelchateau/Documents/experts/expertsFichier.csv')
return csv:parse($text, map { 'header': true() })