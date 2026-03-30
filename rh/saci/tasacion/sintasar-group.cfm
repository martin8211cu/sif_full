<cf_templateheader title="Consola de tasación">
<cf_web_portlet_start titulo="Resumen de eventos sin tasar">

<cfparam name="url.unidad" default="1" type="numeric">
<cfparam name="url.cantidad" default="30" type="numeric">
<cfset minutos_atras = url.cantidad * url.unidad>
<cfif minutos_atras GT 1440>
	<cfset minutos_atras = 1440>
</cfif>
<cfparam name="url.topcount" default="10">
<cfif ListFind('10,20', url.topcount)>
	<cfset url.topcount = 10>
</cfif>
<cfparam name="url.t" default="S">
<cfset tabl = ListGetAt('ISBeventoSinTasar,ISBeventoLogin,ISBeventoPrepago,ISBeventoMedio', 1+ListFind('L,P,M', url.t))>
<cfset cols = "EVloginName,EVtelefono,access_server,ipaddr">
<cfset hdrs = "Login,Teléfono,Servidor,Dirección IP">
<cfset lookupcmd = ""> 
<!---
para convertirlo en top10 de lo que sea
<cfset tabl = "ISBeventoLogin ev">
<cfset cols = "LGnumero,EVtelefono,access_server,ipaddr">
<cfset hdrs = "Login,Teléfono,Servidor,Dirección IP">
<cfset lookupcmd = "select LGlogin as texto from ISBlogin where LGnumero=">
<cfset lookupcol = "LGnumero">
--->

<cfquery datasource="#session.dsn#" name="mostrar_zero">
	select max(EVregistro) as mostrar_zero
	from ISBeventoBitacora
	AT ISOLATION READ UNCOMMITTED
</cfquery>

<cfquery datasource="#session.dsn#" name="fechabd">
	select getdate() as fecha
</cfquery>

<cfif Len(mostrar_zero.mostrar_zero)>
	<cfset mostrar_zero = mostrar_zero.mostrar_zero>
<cfelse>
	<cfset mostrar_zero = DateAdd('n', -1, fechabd.fecha)>
</cfif>
<cfset mostrar_zero = CreateDateTime(Year(mostrar_zero), Month(mostrar_zero), Day(mostrar_zero),
																Hour(mostrar_zero), Minute(mostrar_zero), Second(mostrar_zero))>

<cfloop list="#cols#" index="colname">
<cfquery datasource="#session.dsn#" name="resumen#colname#">
	select
		TOP #TOPCOUNT#
		#colname# as elem, sum(EVduracion) as cant
	from #tabl#
	where EVtasacion > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', - minutos_atras , mostrar_zero)#">
	and #colname# is not null
	group by #colname#
	order by cant desc
	AT ISOLATION READ UNCOMMITTED
</cfquery>
</cfloop>

<cfoutput>
<form action="index.cfm" method="get" style="margin:0"><table width="900" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td>Examine la siguiente información, y haga clic sobre el elemento que desee consultar para ver el detalle ordenado por duración.<br />

	Solamente se muestra la información procesada en los últimos # NumberFormat( minutos_atras ) # minutos.
	</td>
    <td align="right"><input type="submit" class="btnAnterior" value="Regresar"></td>
  </tr>
</table>
</form>
<table width="900" border="0" cellspacing="0" cellpadding="2">
  <tr class="tituloListas">
    <td style="border-right:double">&nbsp;</td>
	<cfloop list="#cols#" index="colname">
    <td colspan="2" align="center" style="border-right:double">TOP #TOPCOUNT# #ListGetAt(hdrs, ListFind(cols,colname))#</td>
	</cfloop>
  </tr>
  <tr class="tituloListas">
    <td style="border-right:double" align="center">Posición</td>
	<cfloop list="#cols#" index="colname">
    <td>#ListGetAt(hdrs, ListFind(cols,colname))#</td>
    <td style="border-right:double">Segundos</td>
	</cfloop>
  </tr><cfloop from="1" to="#TOPCOUNT#" index="N">
  <cfset listapar = ListGetAt('listaPar,listaNon', n mod 2 + 1)>
  <tr>
    <td valign="top" align="center" class="tituloListas" style="border-right:double"><cfoutput>#NumberFormat(N)#.</cfoutput></td>
	<cfloop list="#cols#" index="colname">
	<cfset elem = Evaluate('resumen#colname#.elem[N]')>
	<cfset cant = Evaluate('resumen#colname#.cant[N]')>
	<cfif Len(lookupcmd) And lookupcol EQ colname>
		<cfquery datasource="#session.dsn#" name="rs_lookup">#PreserveSingleQuotes(lookupcmd)#<cfqueryparam cfsqltype="cf_sql_numeric" value="#elem#"></cfquery>
		<cfset elem = rs_lookup.texto>
	</cfif>
    <td valign="top" class="#listapar#" style="cursor:pointer" onclick="carga('#JSStringFormat(HTMLEditFormat( colname))#','# JSStringFormat(HTMLEditFormat( elem))#')" 
		onmouseover="this.className='#listapar#Sel';" onmouseout="this.className='#listapar#';"><cfif Len(elem)>#HTMLEditFormat(elem)#</cfif></td>
    <td valign="top" class="#listapar#" style="border-right:double"><cfif Len(elem)>#NumberFormat(cant)#<cfelse>&nbsp;</cfif></td>
	</cfloop>
  </tr></cfloop>
</table></cfoutput>

<cf_web_portlet_end> 
<div id="div_detalle"></div>
<iframe id="frame_detalle" src="about:blank" width="1" height="1" frameborder="0" style="display:none">
</iframe>
<cfoutput>
<script type="text/javascript">
<!--
function carga( colname, elem ){
	var fd = document.all ? document.all.frame_detalle : document.getElementById( 'frame_detalle' );
	fd.src= 'sintasar-detalle.cfm?ma=# URLEncodedFormat( minutos_atras ) #&t=# URLEncodedFormat( url.t ) #&colname=' + escape(colname) + '&elem=' + escape(elem);
}
function mostrar(o) {
	var ob = document.all ? document.all[o] : document.getElementById( o );
	ob.style.display = ob.style.display=='' ? 'none':'';
}
//-->
</script>
</cfoutput>
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
<cf_templatefooter>