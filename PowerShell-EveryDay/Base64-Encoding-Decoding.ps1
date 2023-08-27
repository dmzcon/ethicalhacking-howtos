!!! DON'T USE IT FOR ANY CRIMINAL ACTIVITIES !!!

$t = gc \SomePath\ENCODED-ATTACHMENT-FROM-EMAIL.txt
function DecodeUText($bt64) {
return [System.Convert]::FromBase64String($bt64);
}
$d = DecodeUText($t)
sc \SomePath\Decoded-attachment-EXAMPLE.docx $d -encoding byte

=================

$f = gc \SomePath\FILE-TO-ATTACH-EXAMPLE.docx -encoding byte
function EncodeUText($inputparam) {
return [Convert]::ToBase64String($inputparam);
}
$g = EncodeUText($f)
sc \SomePath\ATTACHMENT-TO-USE-IN-MESSAGE.txt $g
