<!--- Basura de Requerir
26
<cfif len(trim(Session.Conlises.Conlis[url.c].requerir))>
	<cffunction name="getEtiqueta" returntype="string" output="false">
		<cfargument name="data" required="yes">
		<cfset arDesplegar = ListtoArray(Session.Conlises.Conlis[url.c].desplegar)>
		<cfset arEtiquetas = ListtoArray(Session.Conlises.Conlis[url.c].etiquetas)>
		<cfloop from="1" to="#ArrayLen(arDesplegar)#" index="i">
			<cfif len(trim(ucase(arDesplegar[i]))) eq len(trim(ucase(data)))>
				<cfreturn arEtiquetas[i]>
			</cfif>
		</cfloop>
		<cfreturn ''>
	</cffunction>
</cfif>
130
<cfif len(trim(Session.Conlises.Conlis[url.c].requerir)) and len(trim(temp_value)) eq 0>
	and 1 = 2
</cfif>
218
<cfif len(trim(Session.Conlises.Conlis[url.c].requerir))>
	if (!funcValidar()) {
		document.lista.nosubmit=true;
		return false;			
	}
</cfif>
225
<cfif len(trim(Session.Conlises.Conlis[url.c].requerir))>
	function funcValidar() {
		var requiredOK = true;
		var errores = "";
		<cfloop list="#Session.Conlises.Conlis[url.c].requerir#" index="item">
			<cfoutput>
				document.lista.filtro_#trim(item)#.alt = '#trim(item)#';
				if (document.lista.filtro_#trim(item)#.value == '') {
					requiredOK = false;
					errores = errores + " - El campo #getEtiqueta(trim(item))# es requerido.\n";
				}
			</cfoutput>
		</cfloop>
		if (errores.length) {
			alert(errores);
		}
		return requiredOK;
	}
</cfif>

--->
<!--- Incluye variables de session, requiere registrarse --->
<cfinclude template="/home/Application.cfm">
<!--- Sección de puebas --->
<!--- Prueba componente de conlicese
	REQUERIMIENTOS:
	1. PONER PARÁMETRO PARA FILTROS REQUERIDOS
	2. NO FILTRAR CUANDO HAY FILTROS REQUERIDOS
	3. PONER PARÁMETRO PARA NO VALIDAR CAMPOS MODIFICABLES
--->
<form action="dag.cfm" method="post" name="form1">
<cf_conlis 
	campos="Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion"
	desplegables="S,S,S,S,S,S"
	modificables="N,N,N,N,N,N"
	scrollbars="yes"
	size="20,20,20,20,20,20"
	valuesarray="#ListToArray(' , , , , , ')#"
	title="Lista de Transacciones"
	tabla="GATransacciones2"
	columnas="Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion"
	filtro="Ecodigo = 1 order by Cconcepto, GATperiodo, GATmes, Edocumento"
	conexion="minisif"
	desplegar="Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion"
	requeridos="S,S,S,N,N,N"
	filtrar_por="Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion"
	etiquetas="Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion"
	formatos="I,I,I,I,D,S"
	align="left,left,left,left,left,left"
	asignar="Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion"
	asignarformatos="I,I,I,I,D,S"
	MaxRows="15"
	MaxRowsQuery="150"
	debug="false"
	showEmptyListMsg="true"
	EmptyListMsg="No Hay Datos, Sorry, Je Je!!!"
	funcion=""/>
</form>