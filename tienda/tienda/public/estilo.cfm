<cfquery datasource="#session.dsn#" name="css">
	select font
	from ArteTienda
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>
<style type="text/css">
<!--
.cuadro {
	border: none;
	background-color: #f8f8f8;
}

.small {
	font-size: xx-small;
}

textarea.flat,input.flat,input.flat_money { border: solid 1px silver; }
input.flat_money { text-align: right; }

*,td {font-size:10pt; font-family: <cfoutput>#css.font#</cfoutput>;}
.top {font-weight: bold; font-size: 7pt;}
h1 {margin:0; font-size: 12pt; }
h2.catego {margin:0; font-size: 12pt; font-weight: bold; color:#333333 }
.orderno {color:#FF0000; font-size: medium; }

.enc_item {}
.pie_item {}
.prod_item {font:bold;}
.pres_item {}
.text_item {}
.prec_item {font-size:7pt;}

.enc_matriz {}
.pie_matriz {}
.prod_matriz {font:bold;}
.pres_matriz {font:bold italic;}
.text_matriz {}
.prec_matriz {font-size:7pt;}

.enc_oferta {}
.pie_oferta {}
.prod_oferta {font:bold;font-size:10pt;}
.pres_oferta {font:bold}
.text_oferta {}
.prec_oferta {font-size:9pt;}

.enc_lista {}
.pie_lista {}
.prod_lista {}

.catview_table {
	border-width:1px;
	border-style:solid;
	border-color:#006699; <!--- #FF6699 --->
}
.catview_thinv {
	color: #FFFFFF; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14px;
	border-width:1px;
	border-style:solid;
	border-color:#006699; <!--- #FF6699 --->
	background-color: #3399CC;  <!--- #FF99CC --->;
}
.catview_th {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #006699; <!--- #FF6699 --->
	font-size: 16px;
	font-weight: bold;
}
.catview_price {
	color: #993300;
	font-weight: bold;
}
.catview_link {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	text-decoration:underline;
}
-->
</style>
