<cfparam name="ExtraParams" default="">
<cfset ExtraParams= IIF(len(trim(ExtraParams)),DE("&"),DE("")) & ExtraParams>
<cflocation url="#Request.redirect##ExtraParams#">
