<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">


<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.CFid as pk, c.CFcodigo as codigo, c.CFdescripcion as descripcion, c.CFnivel as nivel,  
		c.CFpath as path,
		(select count(1) from CFuncional c2
			where c2.CFidresp = c.CFid
			  and c2.Ecodigo = c.Ecodigo) AS  hijos,
		{fn concat({fn concat({fn concat({fn concat(
		de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as jefe_actual
	from CFuncional c
	left join RHPlazas p
		on p.RHPid = c.RHPid
	left join LineaTiempo lt
		on lt.RHPid = p.RHPid
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between lt.LTdesde and lt.LThasta
	left join DatosEmpleado de
		on de.DEid = lt.DEid
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by c.CFpath
</cfquery>

<style type="text/css">
<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
.ar1 {background-color:#D4DBF2;cursor:pointer;}
.ar2 {background-color:#ffffff;cursor:pointer;}
</style>
<script type="text/javascript" language="javascript">
<!--
<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
function eovr(row){<!--- event: MouseOver --->
	row.style.backgroundColor='#e4e8f3';
}
function eout(row){<!--- event: MouseOut --->
	row.style.backgroundColor='#ffffff';
}
function eclk(row){<!--- event: Click --->
	if (!row.id) return;
	var rowid = row.id;
	var img = document.getElementById('im'+rowid);
	row.is_hidden = !row.is_hidden;
	var trs = document.getElementById('tabla_arbol').rows;
	var display = row.is_hidden ? 'none' : '';
	var imgsrc = row.is_hidden ? "/cfmx/rh/js/xtree/images/foldericon.png" : "/cfmx/rh/js/xtree/images/openfoldericon.png";
	var idchanged = '';
	for (var i = 0; i < trs.length; i++) {
		var r = trs[i];
		if (r.id && r.id.length > rowid.length && r.id.substring(0,rowid.length) == rowid ) {
			r.style.display = display;
			r.is_hidden = row.is_hidden;
			idchanged = idchanged + ' ' + r.id;
			//document.getElementById('im'+r.id).src = imgsrc;
		}
	}
	img.src = img_src;
	//alert(idchanged);
}
//-->
</script>

<cfinclude template="/home/menu/pNavegacion.cfm">

<div class="subTitulo">&nbsp;</div>


	<table cellpadding="1" cellspacing="0" border="0" width="950" vspace="0" id="tabla_arbol">
	<tr valign="middle"
			class='ar2'
			onMouseOver="eovr(this)"
			onMouseOut="eout(this)"
			onClick="eclk('')"
			><td nowrap>
		<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" alt="[-]" width="16" height="16" border="0" align="absmiddle">
			Centros Funcionales
	</td><td>&nbsp;</td></tr>
	<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
<cfoutput query="ARBOL" group="pk">
<tr valign="middle"	class='ar2' onMouseOver="eovr(this)"
onMouseOut="eout(this)" id="tr#ARBOL.path#" <cfif ARBOL.hijos> onClick="eclk(this)"</cfif>
onDblClick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
 ><td nowrap width="400">
#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
<cfif ARBOL.hijos>
<img id="imtr#ARBOL.path#" src="/cfmx/rh/js/xtree/images/openfoldericon.png" alt="[-]" width="16" height="16" border="0" align="absmiddle">
<cfelse>
<img id="imtr#ARBOL.path#" src="/cfmx/rh/js/xtree/images/file.png" alt="" width="16" height="16" border="0" align="absmiddle">
</cfif>
#HTMLEditFormat(Trim(ARBOL.codigo))# - #HTMLEditFormat(Trim(ARBOL.descripcion))#
</td>
<td width="550">
	<cfset first = true>
<cfoutput>
<cfif not first><br></cfif>
#HTMLEditFormat(Trim(ARBOL.jefe_actual))#&nbsp;<cfset first=false></cfoutput></td>
</tr>
</cfoutput>
	</table>


<cf_templatefooter>
