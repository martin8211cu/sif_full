<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Calculos" 	default="Calculos Realizados" 
returnvariable="LB_Calculos" xmlfile="consultar-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_RegresarCalculo" 	default="Regresar a c&aacute;lculo..." returnvariable="LB_RegresarCalculo" xmlfile="consultar-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DescargarAnexo" 	default="Descargar Anexo" 
returnvariable="LB_DescargarAnexo" xmlfile="consultar-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_MaximizarAnexo" 	default="Maximizar Anexo" 
returnvariable="LB_MaximizarAnexo" xmlfile="consultar-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Seleccion" 	default="Seleccione" 
returnvariable="LB_Seleccion" xmlfile="consultar-form.xml"/>

 
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery datasource="#session.dsn#" name="lista">
	select
		e.ACid, e.AnexoId, e.ACano, e.ACmes,
		e.Mcodigo,
		e.Ocodigo,
		e.ACunidad,
		case 
			when e.Mcodigo = -1 then 'Todas las Monedas (en Local)' 
			when e.ACmLocal = 1 then m.Mnombre #_Cat# ' (en Local)' 
			else m.Mnombre 
		end as Moneda,
		case when e.GEid    != -1 then 'Grupo Empresas: ' #_Cat# ge.GEnombre
		     when e.GOid    != -1 then 'Grupo Oficinas: ' #_Cat# go.GOnombre
		     when e.Ocodigo != -1 then 'Oficina: ' #_Cat# o.Odescripcion
			 else '#session.Enombre#' end as Oficina
	from AnexoCalculo e
		left join Monedas m
			on m.Mcodigo = e.Mcodigo
		left join Oficinas o
			on  o.Ocodigo = e.Ocodigo
			and o.Ecodigo = e.Ecodigo
		left join AnexoGEmpresa ge
			on ge.GEid = e.GEid
		left join AnexoGOficina go
			on go.GOid = e.GOid
	where e.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	  and e.ACstatus = 'T'<!--- T = Terminado (P=Programado,C=Calculado) --->
	  and (
	  	(e.Ecodigo = #session.Ecodigo#)
		
	   		or
		(e.Ecodigo = -1 and e.GEid != -1 and exists (
				select Ecodigo from AnexoGEmpresaDet ged
					where ged.GEid = e.GEid
					  and ged.Ecodigo = #session.Ecodigo#
				)
	    )
	  )
<!---	  and e.Ecodigo in (#session.Ecodigo#, -1) --->
	order by e.ACano desc, e.ACmes desc, e.Mcodigo asc, 
		e.GEid asc, e.GOid asc,
		e.Ocodigo asc, e.ACunidad asc
</cfquery>

<cfparam name="url.ACid" default="">
	<cfif Len(url.ACid)>
	<cfquery datasource="#session.dsn#" name="rsAnexoXml">
		select e.ACid, e.AnexoId, e.ts_rversion
		from AnexoCalculo e
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">		  
		  and ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACid#">
		  and ACstatus = 'T'<!--- T = Terminado (P=Programado,C=Calculado) --->
		  and (
	  	(e.Ecodigo = #session.Ecodigo#)
		
	   		or
		(e.Ecodigo = -1 and e.GEid != -1 and exists (
				select Ecodigo from AnexoGEmpresaDet ged
					where ged.GEid = e.GEid
					  and ged.Ecodigo = #session.Ecodigo#
				)
	    )
	  )
	</cfquery>
	
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="tsurl"
		arTimeStamp="#rsAnexoXml.ts_rversion#"/>
</cfif> 

<cfif isdefined("LvarInfo")>
	<cfset LvarAction = 'index_INFO.cfm'>
	<cfset Recalcular = '/cfmx/sif/an/operacion/calculo/index.cfm'>
<cfelse>
	<cfset LvarAction = 'index.cfm'>
	<cfset Recalcular = '/cfmx/sif/an/calculo/index.cfm'>
</cfif>

<form name="formAnexoMain" id="formAnexoMain" method="get" action="#LvarAction#">
	<cfoutput>
	<input type="hidden" name="AnexoId" id="AnexoId" value="#HTMLEditFormat(url.AnexoId)#">
	</cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td colspan="10">
		  <cfoutput>#LB_Calculos#:</cfoutput>
		  <select name="ACid" onchange="cargar_anexo(this.value)">
		  <option value="">-<cfoutput>#LB_Seleccion#</cfoutput>-</option>
		  <cfoutput query="lista">
		  	<option value="#ACid#" <cfif lista.ACid EQ url.ACid>selected</cfif>>#ACmes#/#ACano# #HTMLEditFormat(Moneda)# - #HTMLEditFormat(Oficina)# </option>
		  </cfoutput>
		  </select>
		  </td>
	  </tr>
		<tr> 
			<td colspan="10" style="border:1px solid #CCCCCC"> 
			<cfoutput>
				<iframe name="ifrQuery" id="ifrQuery" width="100%" height="288" src="/cfmx/sif/an/html/query.cfm?tipo=C&ACid=<cfif isdefined("rsAnexoXml.ACid")>#rsAnexoXml.ACid#</cfif>">
				</iframe>
			</cfoutput>
			</td>
		</tr>
		<tr>
		  <td colspan="10" align="center">&nbsp;  
			  
		  </td>
	  </tr>
		<tr><cfoutput>
		  <td colspan="10" align="center"> 
		  	<cfif isdefined("session.AN.calculo") AND session.AN.calculo> 
			  <input type="button" name="Recalcular" value="#LB_RegresarCalculo#" onclick="recalcular(this.form)">
			</cfif>
			  <input type="button" name="Maximizar" id="Maximizar" value="#LB_MaximizarAnexo#" onclick="Maximizar_archivo(this.form)">
			  <input type="button" name="Descargar" id="Descargar" value="#LB_DescargarAnexo#" onclick="descargar_archivo(this.form)">
		  </td></cfoutput>
	  </tr>
	</table>
</form>

<script type="text/javascript">
<!--
	function recalcular(f)
	{
		<cfoutput>
		window.open( "../calculo/index.cfm?AnexoId="+escape(f.AnexoId.value)+
				   "&GAid=#JSStringFormat(url.GAid)#", "_self");
		</cfoutput>
	}
	function cargar_anexo(LvarACid)
	{
		document.getElementById("Descargar").disabled = false;
		document.getElementById("Maximizar").disabled = false;
		document.getElementById('ifrQuery').src="/cfmx/sif/an/html/query.cfm?tipo=C&ACid=" + LvarACid;
	}
	function descargar_archivo(f){
		if (f.ACid.value.length) {
			var d = new Date();
			window.open("/cfmx/sif/an/operacion/consulta/download/download.cfm?AnexoId="+escape(f.AnexoId.value)+
			           "&ACid="+escape(f.ACid.value)+"&xls=1&tsurl="+d, "_self");
		}
	}
	function Maximizar_archivo(f){
		if (f.ACid.value.length) {
			window.open("/cfmx/sif/an/html/query.cfm?tipo=C&ACid=" + f.ACid.value, 
						"_new",
						"toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes");
			
		}
	}
	if(document.mostrarDescargar)
		document.getElementById('Descargar').style.display="inline";
//-->
</script>