
<cfoutput>
	<form name="goClear" action="index.cfm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="CEcodigo" value="#form.CEcodigo#">
	<input type="hidden" name="Ecodigo" value="#form.Ecodigo#">
	<input type="hidden" name="SScodigo" value="#form.SScodigo#">
	<input type="hidden" name="CDPid" value="">
	</form>
</cfoutput>

<script language="javascript">
	function goPage(){ 
		document.goClear.submit();
	}
</script>

<cfif isdefined("form.BTNOmiteCarga") and form.BTNOmiteCarga EQ 1>
	<cfquery name="rsTablaTemp" datasource="asp">
		Update CDParametros
		set CDPomitir =#form.OmiteVal#
		where CDPid = #form.CDPid#
	</cfquery>

	<script language="javascript">
		goPage();
	</script>
	
</cfif>

<cfif isdefined("form.BTNBorrarCargaTemp") and form.BTNBorrarCargaTemp EQ 1>
	<cfquery name="rsTablaTemp" datasource="asp">
		select CDPtablaCarga,Ecodigo,SScodigo
		from CDParametros
		where CDPid = #form.CDPid#
	</cfquery>
	<cfquery name="rsGetEco" datasource="asp">
		select Ereferencia
		from Empresa
		where Ecodigo = #rsTablaTemp.Ecodigo#
	</cfquery>
	<cfquery datasource="minisif">
		Delete #rsTablaTemp.CDPtablaCarga#
		where Ecodigo = #rsGetEco.Ereferencia#
		and CDPcontrolg = 0
	</cfquery>
	<script language="javascript">
		goPage();
	</script>		
</cfif>


<cfquery name="rsData" datasource="asp">
	select CDPid, CDPorden, CDPtabla, CDPtablaCarga
	from CDParametros
	where Ecodigo = #form.Ecodigo#
	and rtrim(SScodigo) = rtrim('#form.SScodigo#')
	order by CDPorden
</cfquery>
<cfset checked = "<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>">
<cfset unchecked = "<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>">
<cfloop query ="rsData">
	<cfquery name="rsv" datasource="#Gvar.Conexion#">
		select count(1) as recordcountm
		from #rsData.CDPtablaCarga#
		where Ecodigo = #Gvar.Ecodigo#
		and CDPcontrolv = 1
	</cfquery>
	
	<cfquery name="rsc" datasource="#Gvar.Conexion#">
		select count(1) as recordcountm
		from #rsData.CDPtablaCarga#
		where Ecodigo = #Gvar.Ecodigo#
		and CDPcontrolv = 1
		and CDPcontrolg = 1
		and 0 =(select count(1) from #rsData.CDPtablaCarga# where Ecodigo = #Gvar.Ecodigo# and CDPcontrolgt =0)
	</cfquery>
	
	<cfquery datasource="asp">
		update CDParametros
		set CDPcontrolv = <cfif rsv.recordcountm gt 0>1<cfelse>0</cfif>,
		CDPcontrolg = <cfif rsc.recordcountm gt 0>1<cfelse>0</cfif>
		where CDPid = #rsData.CDPid#
	</cfquery>
	
</cfloop>

<cfquery name="getCargasIniciales" datasource="asp">
	select CDPid, CDPorden, CDPtabla, case CDPcontrolv when 0 then '#unchecked#' else '#checked#' end as CDPvalidado, 
			case CDPcontrolg when 0 then '#unchecked#' else '#checked#' end  as CDPcargado, CDPtablaCarga, CDPrutaValida, 
			CDPrutaProcesa, CDPdependencias, CDPcontrolv, CDPcontrolg, CDPomitir
	from CDParametros
	where Ecodigo = #form.Ecodigo#
	and SScodigo = '#form.SScodigo#' 
	order by CDPorden
</cfquery>

<!---Toma el Ereferencia de asp para usarlo como Ecodigo en minisif--->
<cfquery datasource="asp" name="rsEmpresa">
	select Ereferencia from Empresa where Ecodigo=#form.Ecodigo#
</cfquery> 
<cfset rsRef = rsEmpresa.Ereferencia>

<!---llama a cargar los exportadores de ser necesario--->
<cfinclude template="precargaExportadores.cfm">

<cffunction access="private" description="Obtiene si está cargada una estructura" name="getVCarga" returntype="boolean">
	<cfargument name="CDPorden" required="yes" type="string">
	<cfquery name="rs" dbtype="query">
		select 1 
		from getCargasIniciales
		where CDPorden = #CDPorden#
		and CDPcontrolv = 1
		and CDPcontrolg = 1
	</cfquery>
	<cfreturn rs.recordcount gt 0>
</cffunction>

<!--- Note use of HTMLTable attribute to display cftable as an HTML table, rather than as PRE formatted information --->
<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
	<td class="tituloListas" align="left" nowrap></td>
	<td class="tituloListas" align="left" nowrap>Tabla Destino</td>
	<td class="tituloListas" align="left" nowrap>Validado</td>
	<td class="tituloListas" align="left" nowrap>Cargado</td>
	<td class="tituloListas" align="left" nowrap>Tabla de Carga</td>
	<!--- <td class="tituloListas" align="left" nowrap>Validaci&oacute;n</td>
	<td class="tituloListas" align="left" nowrap>Procesamiento</td> --->
	<td class="tituloListas" align="left" nowrap>Dependencias</td>
	<td class="tituloListas" align="left" nowrap>Formatos</td>
	<td class="tituloListas" align="left" nowrap>Importar</td>
	<td class="tituloListas" align="left" nowrap>Borras <br /> Temporales</td>
	<td class="tituloListas" align="left" nowrap>Generar</td>
	<td class="tituloListas" align="left" nowrap>Omitir <br /> Validaci&oacute;n</td>
	<!---<td class="tituloListas" align="left" nowrap>Importar</td>--->
</tr>
	<cfoutput query = "getCargasIniciales">
	<!--- each cfcol tag sets width of a column in table, and specifies headerinformation and text/CFML with which to fill cell --->
		<cfset LvarListaNon = (CurrentRow MOD 2)>
		<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))> 
		
		<cfif getCargasIniciales.CDPomitir EQ 0>	<!---Omitir validacion--->
			
			<cfset LvarVDependencias = 1>
			<cfif len(trim(CDPdependencias)) GT 0>
				<cfloop List="#CDPdependencias#" index="item">
					<cfif NOT getVCarga(item)>
						<cfset LvarVDependencias = 0><!--- Mientras se cumpla es verdadero --->
					</cfif>
				</cfloop>
			</cfif>
		<cfelse>
			<cfset LvarVDependencias = 1>
		</cfif>
		<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
			<td class="#LvarClassName#" align="left"
				style="padding-right: 3px; cursor: pointer;" >
				#CDPorden#
			</td>
			<td class="#LvarClassName#" align="left"
				style="padding-right: 3px; cursor: pointer;" >
				#CDPtabla#
			</td>
			<td class="#LvarClassName#" align="left"
				style="padding-right: 3px; cursor: pointer;" >
				#CDPvalidado#				
			</td>
			<td class="#LvarClassName#" align="left"
				style="padding-right: 3px; cursor: pointer;" >
				#CDPcargado#
			</td>
			<td class="#LvarClassName#" align="left"
				style="padding-right: 3px; cursor: pointer;" >
				#CDPtablaCarga#
			</td>
			<td class="#LvarClassName#" align="left"
				style="padding-right: 3px; cursor: pointer;" >
				#CDPdependencias#
			</td>
			<td class="#LvarClassName#" align="center" style="padding-right: 3px; cursor: pointer;" title="Formato que debe tener el archivo a importar.">
				<a href="#CDPtabla#.xls"><img src="/cfmx/sif/imagenes/excel16x16.gif" width="16" height="16" border="0"></a>
			</td>
			<!---CarolRS Nueva columna con Links a los importadores--->
			<td class="#LvarClassName#" align="center" style="padding-right: 3px; cursor: pointer;" title="Cargar Datos Desde Archivo">
				<a href="/cfmx/sif/importar/ScriptExec.cfm?tbl=#CDPtablaCarga#" target="blank">
					<img src="/cfmx/sif/imagenes/Recordset.gif" width="16" height="16" border="0" >
				</a>
			</td>
			<!--- Nueva columna borra Links para la generacion de datos--->
			<td class="#LvarClassName#" align="center" style="padding-right: 3px; cursor: pointer;" title="Borrar Carga Temporal de #CDPtablaCarga#">
					<img src="/cfmx/sif/imagenes/delete.small.png" width="16" height="16" border="0" onclick="javascript: return funcBorrarCargaTemp(#CDPid#,#LvarVDependencias#)" style="cursor:pointer">
			</td>
			<!--- Nueva columna con Links para la generacion de datos--->
			<td class="#LvarClassName#" align="center" style="padding-right: 3px; cursor: pointer;" title="Generacion de Datos">
				<img src="/cfmx/sif/imagenes/genScript.gif" width="16" height="16" border="0" onclick="javascript: return funcProcesar(#CDPid#,#LvarVDependencias#)" style="cursor:pointer">
			</td>
			<!--- Nueva columna con Links para omitir la validacion de carga de datos--->
			<td class="#LvarClassName#" align="center" style="padding-right: 3px; cursor: pointer;" title="Omitir Validacion">
				<input name="Omitir" id="Omitir" type="checkbox" value="#CDPid#"  onclick="javascript: return funcOmitirCarga(#CDPid#,#LvarVDependencias#,this)" <cfif getCargasIniciales.CDPomitir EQ 1> checked="checked"</cfif> />
			</td>
		</tr>
	</cfoutput>
</table>
<cfoutput>
	<form name="lista" action="index.cfm" method="post">
	<input type="hidden" name="CEcodigo" value="#form.CEcodigo#">
	<input type="hidden" name="Ecodigo" value="#form.Ecodigo#">
	<input type="hidden" name="SScodigo" value="#form.SScodigo#">
	<input type="hidden" name="CDPid" value="">
	<input type="hidden" name="BTNBorrarCargaTemp" value="0">
	<input type="hidden" name="BTNOmiteCarga" value="0">
	<input type="hidden" name="BTNGenerarCarga" value="0">
	<input type="hidden" name="OmiteVal" value="0">
	</form>
</cfoutput>
<script language="javascript">
	function funcProcesar(v,c){
		if (c==1){
		document.lista.CDPid.value=v;
		document.lista.BTNGenerarCarga.value=1;
		document.lista.submit();
		}
		else{
			alert("Debe terminar la(s) carga(s) requerida(s)!");
		}
		return false;
	}
	function funcBorrarCargaTemp(v,c){
		if(confirm ('Desea borrar la tabla temporal?')){
			if (c==1){
			document.lista.CDPid.value=v;
			document.lista.BTNBorrarCargaTemp.value=1;
			document.lista.submit();
			}
			else{
				alert("Debe terminar la(s) carga(s) requerida(s)!");
			}
		}
		else{
			return false;
		}
	}
	
	function funcOmitirCarga(v,c,ck){
		if(ck.checked){
			document.lista.OmiteVal.value=1;
		}else{
			document.lista.OmiteVal.value=0;
		}
		document.lista.BTNOmiteCarga.value=1;
		document.lista.CDPid.value=v;
		document.lista.submit();
	}
</script>