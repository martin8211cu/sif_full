<!---
	Israel Rodríguez 16-Oct-2014

--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PopupBlock" default="Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio:" returnvariable="MSG_PopupBlock" xmlfile="/sif/TagsSIF/sifComprobateFisal.xml"/>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 				default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.Ecodigo"			default="#session.Ecodigo#" type="string"> <!---Ecodigo de la Expresa --->
<cfparam name="Attributes.Origen" 			default="-1" 				type="string"> <!--- Módulo Origen  --->
<cfparam name="Attributes.IDdocumento" 		default="-1" 				type="string"> <!--- Id del Documento --->
<cfparam name="Attributes.Documento" 		default="" 				type="string"> <!--- Documento  --->
<cfparam name="Attributes.IDlinea" 			default="-1" 				type="string"> <!--- Id de la Línea --->
<cfparam name="Attributes.Nombre"			default="" 				type="string"> <!--- Nombre --->
<cfparam name="Attributes.irA"				default="" 				type="string"> <!--- Refrescar --->
<cfparam name="Attributes.modo"				default="" 				type="string"> <!--- define si el popup va a salvar a la db --->
<cfparam name="Attributes.click"			default="" 				type="string"> <!--- simular el clik de un boten del form --->
<cfparam name="Attributes.size"				default="40" 			type="integer"> <!--- tamaño del text --->
<cfparam name="Attributes.SNidentificacion"	default="" 				type="string"> <!--- RFC del socio de negocio --->
<cfparam name="Attributes.imagenUbicacion"	default="../../imagenes/Description.gif" 				type="string"> <!--- RFC del socio de negocio --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TimbreFiscal" default="Timbre Fiscal UUID" returnvariable="LB_TimbreFiscal" xmlfile="sifComprobanteFiscal.xml"/>

<!--- consultas --->
<!--- query --->
<cfquery name="getContE" datasource="#Session.DSN#">
	select ERepositorio from Empresa
	where Ereferencia = #Session.Ecodigo#
</cfquery>

<cfquery name="rsValMON" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset valMON = "N">
<cfif #rsValMON.RecordCount#  neq 0>
	<cfset valMON = rsValMON.Pvalor>
</cfif>
<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
	<cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
	<cfset repodbname = LobjRepo.getnameDB(#session.Ecodigo#)>


	<cfset miniModo ="ALTA">
	<cfif Attributes.modo EQ "">
		<cfset dbreponame = "">
	<cfset isFirst = "true">
	<cfif isdefined("Attributes.Origen") and len(trim('Attributes.Origen')) >
		<cfquery name="getDoc" datasource="#Attributes.Conexion#">
			select TimbreFiscal from CERepoTMP
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Origen#">
			<cfif Attributes.Origen EQ "TES" or Attributes.Origen EQ "TSGS">
				and ID_Linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDlinea#">
			<cfelse>
		    	and ID_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDdocumento#">
			</cfif>
	    </cfquery>
	</cfif>

	<!--- query --->
	<cfif isdefined('getDoc') and getDoc.RecordCount GT 0>
		<cfset miniModo = "CAMBIO">
	<cfelseif isdefined("Attributes.Documento") and len(trim(Attributes.Documento)) and Attributes.Origen EQ "TES">
		<!--- buscar si el documento ya tiene CFDI --->
		<cfquery name="getDoc" datasource="#Attributes.Conexion#">
			select TimbreFiscal
			from CERepoTMP rt
			inner join TESdetallePago ds
				on rt.ID_Linea = ds.TESDPid
			inner join TESsolicitudPago eds
				on eds.TESSPid = ds.TESSPid
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Origen#">
				and ID_Linea <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDlinea#">
				and ds.TESDPdocumentoOri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Documento#">
				and (
						eds.SNcodigoOri = (select a.SNcodigoOri from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDlinea#">)
						or eds.TESBid = (select a.TESBid from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDlinea#">)
				)
			union all
			select timbre as TimbreFiscal from #dbreponame#CERepositorio rt
			inner join TESdetallePago ds
				on rt.IdDocumento = ds.TESDPid
				and rt.origen = 'TES'
			inner join TESsolicitudPago eds
				on eds.TESSPid = ds.TESSPid
			where rt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ds.TESDPdocumentoOri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Documento#">
				and (
						eds.SNcodigoOri = (select a.SNcodigoOri from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDlinea#">)
						or eds.TESBid = (select a.TESBid from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDlinea#">)
				)
		</cfquery>

		<cfif isdefined('getDoc') and getDoc.RecordCount GT 0>
			<cfset miniModo = "CAMBIO">
			<cfset isFirst = "false">
		</cfif>

	<cfelseif isdefined("Attributes.Documento") and len(trim(Attributes.Documento)) and Attributes.Origen EQ "TSGS">
			<cfquery name="getDoc" datasource="#Attributes.Conexion#">
				select TimbreFiscal from CERepoTMP rt
				inner join GEliquidacionGasto glg on rt.ID_Linea = glg.GELGid
				inner join GEliquidacion gl on gl.GELid = glg.GELid
				where rt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and rt.Origen = 'TSGS'
				and rt.ID_Linea <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDlinea#">
				and rt.ID_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.IDdocumento#">
				and glg.GELGnumeroDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Documento#">
		</cfquery>
		<cfif isdefined('getDoc') and getDoc.RecordCount GT 0>
			<cfset miniModo = "CAMBIO">
			<cfset isFirst = "false">
		</cfif>

	</cfif>


	<!--- <cf_dump var="#getDoc#"> --->

	<cfif Attributes.Origen EQ "CPFC">
	 	<cfquery name="getSocio" datasource="#session.dsn#">
	        select SNcodigo from EDocumentosCxP
	        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and IDdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.IDdocumento#">
		</cfquery>
	    <cfset SNcodigo = getSocio.SNcodigo>
	</cfif>
	<cfif Attributes.Origen EQ "CCFC">
	 	<cfquery name="getSocio" datasource="#session.dsn#">
	        select SNcodigo from EDocumentosCxC
	        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and EDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.IDdocumento#">
		</cfquery>
	    <cfset SNcodigo = getSocio.SNcodigo>
	</cfif>
	<cfif Attributes.Origen EQ "TES">
	 	<cfquery name="getSocio" datasource="#session.dsn#">
	        select isnull(cast(SNcodigoOri as numeric),cast(TESBid as numeric)) SNBid,
				case
					when SNcodigoOri is not null then 'SN'
					when SNid is not null then 'SN'
					when TESBid is not null then 'BN'
					else null
				end TipoSN
			from TESsolicitudPago
	        where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.IDdocumento#">
		</cfquery>
	    <cfset SNcodigo = getSocio.SNBid>
	</cfif>
	<cfif Attributes.Origen EQ "TSGS">
	 	<cfquery name="getSocio" datasource="#session.dsn#">
	        Select 	isnull(cast(dl.SNcodigo as numeric),cast(dl.TESBid as numeric)) SNBid,
	        	case
					when dl.SNcodigo is not null then 'SN'
					when dl.TESBid is not null then 'BN'
					else null
				end TipoSN
		from GEliquidacionGasto dl
			left join CFuncional cf
			  on cf.CFid = dl.CFid
		where dl.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.IDlinea#">
	    </cfquery>
	    <cfset SNcodigo = getSocio.SNBid>
	</cfif>
	</cfif>

	<cfoutput>
		<script language="JavaScript">
			var popUpWin#Attributes.nombre#=0;

			function popUpWindow#Attributes.nombre#(URLStr, left, top, width, height){
				if(popUpWin#Attributes.nombre#) {
					if(!popUpWin#Attributes.nombre#.closed) popUpWin#Attributes.nombre#.close();
			  	}
			  	popUpWin#Attributes.nombre# = open(URLStr, 'popUpWin#Attributes.nombre#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				if (! popUpWin#Attributes.nombre# && !document.popupblockerwarning) {
					alert('#MSG_PopupBlock#  ' + location.hostname);
					document.popupblockerwarning = 1;
				  }
				  else
				  	if(popUpWin#Attributes.nombre#.focus) popUpWin#Attributes.nombre#.focus();
			}

			function closePopUp(){
				if(popUpWin#Attributes.nombre#) {
					if(!popUpWin#Attributes.nombre#.closed) popUpWin#Attributes.nombre#.close();
					popUpWin#Attributes.nombre#=null;
			  	}
			}

			function timbreFiscal#Attributes.nombre#()
				{
					<cfif Attributes.modo EQ "">
					<cfif SNcodigo NEQ "">
						popUpWindow#Attributes.nombre#("/cfmx/sif/ce/operacion/formComprobanteFiscal.cfm?nombre=#Attributes.Nombre#&form=#Attributes.form#&doc=#trim(Attributes.Documento)#&docID=#Attributes.IDdocumento#&origen=#Attributes.Origen#&SNcodigo=#SNcodigo#&IDlinea=#Attributes.IDlinea#",250,200,650,350);
						</cfif>
					<cfelse>
						popUpWindow#Attributes.nombre#("/cfmx/sif/ce/operacion/formComprobanteFiscal.cfm?nombre=#Attributes.Nombre#&form=#Attributes.form#&origen=#Attributes.Origen#&modo=alta&SNidentificacion=#Attributes.SNidentificacion#",250,200,650,350);
					</cfif>
				}

			function limpiarCFDI#Attributes.nombre#()
				{
					document.#Attributes.form#.#Attributes.nombre#.value="";

				}
			<cfif Attributes.irA NEQ "">
			function funcRefrescar#Attributes.nombre#(){
				document.#Attributes.form#.action = '#Attributes.irA#';
				document.#Attributes.form#.submit();
			}
			</cfif>

			<cfif Attributes.irA EQ "" and Attributes.click NEQ "">
			function funcClick#Attributes.nombre#(){
				document.#Attributes.form#.#Attributes.click#.click();
			}
			</cfif>
		</script>
	</cfoutput>

	<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td >
	        	<input name="#Attributes.nombre#" id="#Attributes.nombre#" tabindex="1" onFocus="javascript:this.select();" type="text" readonly="readonly"
					   value="<cfif miniModo NEQ "ALTA"><cfoutput>#HTMLeditFormat(getDoc.TimbreFiscal)#</cfoutput></cfif>"
					  size="#Attributes.size#" maxlength="37">
	            <cfif miniModo NEQ "ALTA" and not isFirst>
					<!--- no se muestra nada --->
				<cfelse>
					<a href="javascript:void(0)" tabindex="-1"> <img src="#Attributes.imagenUbicacion#" alt="Timbre Fiscal"
					  id="ce_refimagen"  name="ce_refimagen" width="18" height="14" border="0" align="absmiddle" onclick="javascript:timbreFiscal#Attributes.nombre#();" /> </a>
				</cfif>
			   <!---  <a href="javascript:void(0)" tabindex="-1"> <img src="../../imagenes/delete.small.png" alt="Limpiar CFDI" name="imagenLimpiar"
	                    width="16" height="16" 	border="0" align="absmiddle" onclick="javascript:limpiarCFDI#Attributes.nombre#();" on /> </a></cfif> --->
	            <cfif Attributes.modo NEQ "">
					  <input type="hidden" name="ce_AFnombreImagen" value="">
					  <input type="hidden" name="ce_AFnombre" value="">
					  <input type="hidden" name="ce_AFimagenPDF" value="">
					  <input type="hidden" name="ce_AFimagen" value="">
			          <input type="hidden" name="ce_AFnombreImagenSoporte" value="">
					  <input type="hidden" name="ce_AFnombreSoporte" value="">
			          <input type="hidden" name="ce_modo" value="">
			          <input type="hidden" name="ce_origen" value="">
			          <input type="hidden" name="ce_optTipoComprobante" value="">
			          <input type="hidden" name="ce_TimbreFiscal" value="">
			          <input type="hidden" name="ce_tFolio" value="">
			          <input type="hidden" name="ce_tSerie" value="">
			          <input type="hidden" name="ce_NomArchSoporte" id="NomArchSoporte" value="" />
                	  <input type="hidden" name="ce_ExtArchSoporte" id="ExtArchSoporte" value="" />
					  <input type="hidden" name="ce_nombre_xTMP" id="ce_nombre_xTMP" value="" />
					  <input type="hidden" name="ce_nombre_sTMP" id="ce_nombre_sTMP" value="" />
					<cfif valMON EQ "N">
					  <input type="hidden" name="ce_montoT" value="">
					  <input type="hidden" name="ce_tipoCambio" value="">
					  <input type="hidden" name="ce_Mcodigo" value="">
					</cfif>
				</cfif>
			</td>
		</tr>
	</table>
	</cfoutput>
</cfif>