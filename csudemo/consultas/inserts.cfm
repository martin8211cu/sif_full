<!--- <cfquery name="RsEncabezado" datasource="csulog">       
	select 	*
	from EncPed
	WHERE NUMPEDIDO = '572083'
</cfquery>
<cfquery name="Rsdetalle" datasource="csulog">       
	select 	*
	from DetPed
	WHERE NUMPEDIDO = '572083'

</cfquery> 

<cfdump  var="#Rsdetalle#">

<cfquery name="INSERTEncDesp" datasource="csulog">       
	insert into  DetDesp
	( 	CANTIDADDESPACHADA,
		CANTIDADSOLICITADA,
		CODCLIENTE,
		CODINTPRODUCTO,
		DESCRPRODUCTO,
		DIGITO,
		MONTOTOTDESPACHADO,
		NUMDESPACHO,
		SUBINDICE)
	values
	(	'19',
		'20',
		'37',
		'257',
		'DESC',
		'7',
		'10000',
		'572083',
		'1'
		)
</cfquery>

<cfquery name="RsEncabezado" datasource="csulog">       
	select 	*
	from EncDesp
</cfquery>

<cfdump  var="#RsEncabezado#">--->   
<cfquery name="RsEncabezado" datasource="csulog">    
	select 	*
	from DetDesp
</cfquery>

<cfdump  var="#RsEncabezado#">

