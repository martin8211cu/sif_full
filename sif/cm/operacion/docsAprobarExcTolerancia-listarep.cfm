<cfif isdefined("url.imprimir")>
	<cfoutput>
		<!--- Carga los parámetros que vienen por url, cuando se va a imprimir la lista --->
		
		<cfif isdefined("url.EDRnumeroF") and not isdefined("form.EDRnumeroF")>
			<cfset form.EDRnumeroF = url.EDRnumeroF>
		</cfif>
		<cfif isdefined("url.EDRreferenciaF") and not isdefined("form.EDRreferenciaF")>
			<cfset form.EDRreferenciaF = url.EDRreferenciaF>
		</cfif>
		<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
			<cfset form.FechaF = url.FechaF>
		</cfif>
		<cfif isdefined("url.SNcodigoF") and not isdefined("form.SNcodigoF")>
			<cfset form.SNcodigoF = url.SNcodigoF>
		</cfif>
		<cfif isdefined("url.UsucodigoF") and not isdefined("form.UsucodigoF")>
			<cfset form.UsucodigoF = url.UsucodigoF>
		</cfif>
		
		<style type="text/css">
			.topline {
				border-top-width: 1px;
				border-top-style: solid;
				border-right-style: none;
				border-bottom-style: none;
				border-left-style: none;
				border-top-color: ##CCCCCC;
				font-size:10px;
			}
			.letra {
				font-size:11px;
			}
			td { font-size:9px;	}
		</style>
	
		<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
			<tr> 
				<td colspan="16" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.Enombre#</strong></td>
			</tr>
			<tr> 
				<td colspan="16" class="letra" align="center"><b><font size="2">Listado de Recepciones con Exceso de Tolerancia por Aprobar</font></b></td>
			</tr>
			<tr>
				<td colspan="16" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
	</cfoutput>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Obtiene la lista de la base de datos --->
<cfquery name="rsLista" datasource="#session.DSN#">
	select	edr.EDRid, edr.EDRnumero, edr.EDRreferencia, edr.EDRfechadoc,
			sn.SNnumero #_Cat# '-' #_Cat# sn.SNnombre as SNnombre,
			case when 
				(select count(1)
				 from Usuario usu1
					inner join DatosPersonales dp1
						on dp1.datos_personales = usu1.datos_personales
				 where dp1.Pnombre = dp.Pnombre
					and dp1.Papellido1 = dp.Papellido1
					and dp1.Papellido2 = dp.Papellido2
					and usu1.Usucodigo <> usu.Usucodigo
				 )
				 > 0 then dp.Pnombre #_Cat# ' ' #_Cat# dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 #_Cat# ' (' #_Cat# usu.Usulogin #_Cat# ')'
				 else dp.Pnombre #_Cat# ' ' #_Cat# dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2
			end as Pnombre
			
	from EDocumentosRecepcion edr
		
		inner join SNegocios sn
			on sn.SNcodigo = edr.SNcodigo
			and sn.Ecodigo = edr.Ecodigo
	
		inner join TipoDocumentoR tdr
			on tdr.TDRcodigo = edr.TDRcodigo
			and tdr.Ecodigo = edr.Ecodigo
			and tdr.TDRtipo = <cfqueryparam cfsqltype="cf_sql_char" value="R">
		
		inner join Usuario usu
			on usu.Usucodigo = edr.Usucodigo
			
		inner join DatosPersonales dp
			on dp.datos_personales = usu.datos_personales
	
	where edr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and edr.EDRestado = -5
		and exists (
			select 1
			from DDocumentosRecepcion ddr
			
				inner join DOrdenCM do
					on do.DOlinea = ddr.DOlinea
					and do.Ecodigo = ddr.Ecodigo
					
				inner join EOrdenCM eo
					on eo.EOidorden = do.EOidorden
					and eo.Ecodigo = do.Ecodigo
					
			where ddr.EDRid = edr.EDRid
				and ddr.DDRaprobtolerancia in (5)
				<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador)) gt 0>
				and eo.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.comprador#">
				<cfelse>
				and eo.CMCid = -1
				</cfif>
		)
		<cfif isdefined("form.UsucodigoF") and len(trim(form.UsucodigoF)) gt 0>
			and edr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoF#">
		</cfif>
		<cfif isdefined("form.FechaF") and len(trim(form.FechaF)) gt 0>
			and edr.EDRfechadoc = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaF)#">
		</cfif>
		<cfif isdefined("form.EDRnumeroF") and len(trim(form.EDRnumeroF)) gt 0>
			and upper(edr.EDRnumero) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.EDRnumeroF)#%">
		</cfif>
		<cfif isdefined("form.EDRreferenciaF") and len(trim(form.EDRreferenciaF)) gt 0>
			and upper(edr.EDRreferencia) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.EDRreferenciaF)#%">
		</cfif>
		<cfif isdefined("form.SNcodigoF") and len(trim(form.SNcodigoF)) gt 0>
			and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoF#">
		</cfif>
	order by edr.Usucodigo, edr.EDRnumero
</cfquery>

<cfif isdefined("url.imprimir")>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
</cfif>

<!--- Muestra la lista --->
<cfinvoke component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="cortes" value="Pnombre"/>
	<cfinvokeargument name="desplegar" value="EDRnumero, EDRreferencia, EDRfechadoc, SNnombre"/>
	<cfinvokeargument name="etiquetas" value="N&uacute;mero, Referencia, Fecha, Nombre Socio"/>
	<cfinvokeargument name="formatos" value="S,S,D,S"/>
	<cfinvokeargument name="align" value="left,left,left,left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="keys" value="EDRid"/>
	<cfinvokeargument name="irA" value="docsAprobarExcTolerancia.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfif not isdefined("url.imprimir")>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfelse>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="maxRows" value="0"/>
	</cfif>
</cfinvoke> 

<cfif isdefined("url.imprimir")>
			</td>
		</tr>
	</table>			
</cfif>
