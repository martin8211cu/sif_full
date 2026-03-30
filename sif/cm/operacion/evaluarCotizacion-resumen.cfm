<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Ordenes Generadas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfif isdefined("Url.EOidorden") and Len(Trim(Url.EOidorden))>
    	<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsCotizacion" datasource="#Session.DSN#">
			select 	a.EOidorden, 
					a.EOnumero,
					a.EOtotal,
					b.SNnumero #_Cat# ' - ' #_Cat# b.SNnombre as Proveedor,
					c.Mnombre
					
			from EOrdenCM a
				inner join SNegocios b
					on a.Ecodigo = b.Ecodigo
					and a.SNcodigo = b.SNcodigo
			
				inner join Monedas c
					on a.Ecodigo = c.Ecodigo
					and a.Mcodigo = c.Mcodigo
									
			where a.EOidorden in (#url.EOidorden#)
				<!----a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.EOidorden#">---->
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<cf_templatecss>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloListas">Se Generaron las Siguientes Ordenes de Compras.</td>
		  </tr>
		  <tr>
			<td>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsCotizacion#"/>
					<cfinvokeargument name="desplegar" value="EOnumero, Proveedor, EOtotal, Mnombre"/>
					<cfinvokeargument name="etiquetas" value="No. Orden, Proveedor, Total, Moneda"/>
					<cfinvokeargument name="formatos" value="V, V, M, V"/>
					<cfinvokeargument name="align" value="left, left, right, left"/>
					<cfinvokeargument name="ajustar" value=""/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="formName" value="form1"/>
					<cfinvokeargument name="MaxRows" value="0"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
				</cfinvoke>
			</td>
		  </tr>
		  <tr>
		    <td align="center">&nbsp;</td>
	      </tr>
		</table>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="center">
				<input type="button" name="btnCerrar" value="Cerrar" onClick="javascript: window.close();">
			</td>
		  </tr>
		</table>
	</cfif>

</body>
</html>

