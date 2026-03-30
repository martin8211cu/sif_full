<!--- Recibe conexion, form, name y desc --->
<cfquery datasource="#session.Fondos.dsn#"  name="Tarjetas" >	
	set nocount on 
	create table ##TARJETAS(
		EMPCOD char(8)  null,
		TS1COD  varchar(5) null,
		TR01NUT varchar(20) null,
		CANTIDAD int   null
	)
	insert  ##TARJETAS (TS1COD, EMPCOD,CANTIDAD)
		SELECT CJM014.TS1COD ,CATR01.EMPCOD,count(CJM014.TR01NUT) CANTIDAD
		FROM CJM014,CATR01 
		WHERE   CJM014.TS1COD = CATR01.TS1COD 
		AND 	CJM014.TR01NUT = CATR01.TR01NUT
		AND 	CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Fondo#">
		GROUP BY CATR01.EMPCOD,CJM014.TS1COD

	UPDATE ##TARJETAS
		SET TR01NUT= CATR01.TR01NUT
	from CATR01
		where ##TARJETAS.EMPCOD =  CATR01.EMPCOD
	select  *  from ##TARJETAS
	drop table ##TARJETAS
	set nocount off
</cfquery>
<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#Url.form#.#Url.id#</cfoutput>.value   = id;
		window.opener.document.<cfoutput>#Url.form#.#Url.name#</cfoutput>.value = name;
		window.opener.document.<cfoutput>#Url.form#.#Url.desc#</cfoutput>.value = desc;
		window.opener.document.<cfoutput>#Url.form#.#Url.desc2#</cfoutput>.value = '';		
		var ntarjetas = false;
		<cfoutput query="Tarjetas">
			if (#Tarjetas.EMPCOD#==id) {
				if (#Tarjetas.CANTIDAD#==1) {
				    window.opener.document.#Url.form#.#Url.desc2#.value =  '#Tarjetas.TR01NUT#';
				}
				else{
					ntarjetas = true;			
				}			
			}
		</cfoutput>
		if (ntarjetas) {
			var obj = window.opener;
			obj.listatarjetas(name);
		}
		window.close();
	}
}
</script>

<cfif isdefined("Url.EMPCED") and not isdefined("Form.EMPCED")>
	<cfparam name="Form.EMPCED" default="#Url.EMPCED#">
</cfif>

<cfif isdefined("Url.NOMBRE") and not isdefined("Form.NOMBRE")>
	<cfparam name="Form.NOMBRE" default="#Url.NOMBRE#">
</cfif>

<cfif isdefined("Url.EMPCOD") and not isdefined("Form.EMPCOD")>
	<cfparam name="Form.EMPCOD" default="#Url.EMPCOD#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.EMPCED") and Len(Trim(Form.EMPCED)) NEQ 0>
	<cfset filtro = filtro & cond & " upper(EMPCED) like '%" & #UCase(Form.EMPCED)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EMPCED=" & Form.EMPCED>
    <cfset cond = " and">

</cfif>
<cfif isdefined("Form.NOMBRE") and Len(Trim(Form.NOMBRE)) NEQ 0>
 	<cfset filtro = filtro & cond & " upper(EMPNOM + EMPAPA + EMPAMA) like '%" & #UCase(Form.NOMBRE)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NOMBRE=" & Form.NOMBRE>
	<cfset cond = " and">
</cfif>
<html>
<head>
<title>Catálogo de Empleados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroEmpleado" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Cédula</strong></td>
				<td> 
					<input name="EMPCED" type="text" id="name" size="12" maxlength="12" value="<cfif isdefined("Form.EMPCED")>#Form.EMPCED#</cfif>">
				</td>
				<td align="right"><strong>Nombre</strong></td>
				<td> 
					<input name="NOMBRE" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.NOMBRE")>#Form.NOMBRE#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<cfinvoke 
 component="sif.fondos.Componentes.pListas"
 method="pLista"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="PLM001"/>
 	<cfinvokeargument name="columnas" value="EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE"/>
	<cfinvokeargument name="desplegar" value="EMPCED,NOMBRE"/>
	<cfinvokeargument name="etiquetas" value="Cédula,Nombre"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaempleados"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="EMPCOD,EMPCED,NOMBRE"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>
