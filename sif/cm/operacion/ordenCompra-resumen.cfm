<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Ordenes Generadas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfif isdefined("Url.ESidsolicitud") and Len(Trim(Url.ESidsolicitud))>
		<cfquery name="rsOrdenes" datasource="#Session.DSN#">
			select distinct b.EOidorden, b.EOnumero, b.SNcodigo, b.Mcodigo, b.EOestado, c.SNnombre, d.Mnombre
			from DOrdenCM a
				inner join EOrdenCM b
				on a.Ecodigo = b.Ecodigo
				and a.EOidorden = b.EOidorden
				and b.EOestado in (7,8)
				
				inner join SNegocios c
				on b.Ecodigo = c.Ecodigo
				and b.SNcodigo = c.SNcodigo
				
				inner join Monedas d
				on b.Ecodigo = d.Ecodigo
				and b.Mcodigo = d.Mcodigo
				
			where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.ESidsolicitud#" list="yes">
		</cfquery>

		<cf_templatecss>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloListas">Se generaron las siguientes ordenes de compra</td>
		  </tr>
		  <tr>
			<td>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsOrdenes#"/>
					<cfinvokeargument name="desplegar" value="EOnumero, SNnombre, Mnombre"/>
					<cfinvokeargument name="etiquetas" value="No. Orden, Proveedor, Moneda"/>
					<cfinvokeargument name="formatos" value="V, V, V"/>
					<cfinvokeargument name="align" value="left, left, left"/>
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
