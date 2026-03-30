<cfif isdefined('url.FAGTPdescripcion') and not isdefined('form.FAGTPdescripcion')>
	<cfset form.FAGTPdescripcion = url.FAGTPdescripcion>
</cfif>
<cfif isdefined('url.FAGTPperiodo') and not isdefined('form.FAGTPperiodo')>
	<cfset form.FAGTPperiodo = url.FAGTPperiodo>
</cfif>
<cfif isdefined('url.FAGTPmes') and not isdefined('form.FAGTPmes')>
	<cfset form.FAGTPmes = url.FAGTPmes>
</cfif>
<cfif isdefined('url.FAGTPfalta') and not isdefined('form.FAGTPfalta')>
	<cfset form.FAGTPfalta = url.FAGTPfalta>
</cfif>
<cfif isdefined('url.FAGTPestado') and not isdefined('form.FAGTPestado')>
	<cfset form.FAGTPestado = url.FAGTPestado>
</cfif>

<!--- Query para solo Retiros --->
<cf_dbfunction name="to_sdateDMY" 	args="a.AGTPfechaprog" returnvariable= "FechaProgramacion">
<cf_dbfunction name="to_chartime" 	args="a.AGTPfechaprog" returnvariable= "HoraProgramacion">
<cf_dbfunction name="concat" 		args="'Por Generar <b>Fecha:</B> ' ; #PreserveSingleQuotes(FechaProgramacion)# ; ' <b>Hora:</b> ' ; #PreserveSingleQuotes(HoraProgramacion)#" delimiters= ";" returnvariable="PorGenerar" >
<cf_dbfunction name="concat" 		args="'Por Aplicar <b>Fecha:</B> ' ; #PreserveSingleQuotes(FechaProgramacion)# ; ' <b>Hora:</b> ' ; #PreserveSingleQuotes(HoraProgramacion)#" delimiters= ";" returnvariable="PorAplicar" >

<cfquery name="lista" datasource="#session.DSN#" maxrows="300">
	select 	a.IDtrans,
			a.AGTPid, a.Ecodigo, a.IDtrans, a.AGTPdescripcion, a.AGTPperiodo, a.AGTPmes, a.AGTPfalta, 
			case a.AGTPestadp 
				when 0 then 'En Proceso' 
				when 1 then #PreserveSingleQuotes(PorGenerar)#
				when 2 then #PreserveSingleQuotes(PorAplicar)#
				when 4 then 'Aplicado' 
			end as AGTPestadodesc
	from	AGTProceso a
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.IDtrans in (14)
		and a.AGTPestadp in (0,1,2,4) 
		and a.AGTPecodigo > 0

		<cfif isdefined('form.FAGTPdescripcion') and len(trim(form.FAGTPdescripcion))>
			and upper(a.AGTPdescripcion) like upper('%#form.FAGTPdescripcion#%')
		</cfif>
		<cfif isdefined('form.FAGTPperiodo') and len(trim(form.FAGTPperiodo))>
			and a.AGTPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAGTPperiodo#">
		</cfif>		
		<cfif isdefined('form.FAGTPmes') and len(trim(form.FAGTPmes))>
			and a.AGTPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAGTPmes#">
		</cfif>		
		<cfif isdefined('form.FAGTPfalta') and len(trim(form.FAGTPfalta))>
			and a.AGTPfalta >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FAGTPfalta)#">
		</cfif>
		<cfif isdefined('form.FAGTPestado') and len(trim(form.FAGTPestado))>
			and a.AGTPestadp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAGTPestado#">
		</cfif>		
        
	order by a.AGTPestadp, a.AGTPecodigo, a.AGTPperiodo, a.AGTPmes
</cfquery>


<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
 		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRHRet">
			<cfinvokeargument name="query" value="#lista#"/>
			<cfinvokeargument name="desplegar" value="AGTPdescripcion, AGTPperiodo, AGTPmes, AGTPfalta, AGTPestadodesc"/>
			<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Periodo, Mes, Fecha, Estado"/>
			<cfinvokeargument name="formatos" value="V, V, V, D, V"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="align" value="left, left, left, left, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="repRetiroFiscal.cfm"/>
			<cfinvokeargument name="keys" value="AGTPid"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="radios" value="S"/>
			<cfinvokeargument name="botones" value="Descargar"/>
		</cfinvoke>
	</td>
  </tr>
</table>

<script language="javascript" type="text/javascript">
	<!--
	function funcDescargar(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				if (document.lista.chk.checked) {
					return confirm("¿Desea Descargar El Archivo Seleccionado?");
				}
			} else {
				for (var i=0;i<document.lista.chk.length;i++) {
					if (document.lista.chk[i].checked){
						return confirm("¿Desea Descargar El Archivo Seleccionado?");
					}
				}
			}
			alert("Debe seleccionar la transacción a descargar!");
		} else {
			alert("No hay ninguna transacción para descargar!");
		}
		return false;
	}
	-->
</script>