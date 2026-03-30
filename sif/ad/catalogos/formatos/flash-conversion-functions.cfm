<cfscript>
function BitToBoolean(bit_value){
	if (bit_value is 1)
		return '1';
	else
		return '';
}
function StructToURL(struc){
	var ret = ArrayNew(1);
	for (x in struc){
		ArrayAppend(ret, URLEncodedFormat(LCase(x)) & '=' & URLEncodedFormat(struc[x],'utf-8'));
	}
	return ArrayToList(ret, '&');
}
</cfscript>