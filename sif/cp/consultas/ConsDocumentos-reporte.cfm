<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Lbl_Cesion 	= t.Translate('Lbl_Cesion','CESIÓN')>
<cfset Lbl_Multa 	= t.Translate('Lbl_Multa','MULTA')>
<cfset Lbl_Embargo 	= t.Translate('Lbl_Embargo','EMBARGO')>
<cfset Lbl_EnPrep 	= t.Translate('Lbl_EnPrep','En Preparacion')>
<cfset Lbl_EnApr 	= t.Translate('Lbl_EnApr','En Aprobacion')>
<cfset Lbl_Pendien 	= t.Translate('Lbl_Pendien','Pendiente')>
<cfset Lbl_Aprob 	= t.Translate('Lbl_Aprob','Aprobado')>
<cfset Lbl_Rechaz 	= t.Translate('Lbl_Rechaz','Rechazado')>
<cfset Lbl_Anulado 	= t.Translate('Lbl_Anulado','Anulado')>
<cfset Lbl_Pagado 	= t.Translate('Lbl_Pagado','Pagado')>
<cfset Msg_ConsMEC 	= t.Translate('Msg_ConsMEC','Consulta de Multas, Embargos y Cesiones')>
<cfset Lbl_TipoTran = t.Translate('Lbl_TipoTran','Tipo Transacción')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_FechaDoc 	= t.Translate('LB_FechaDoc','Fecha Doc')>
<cfset LB_FechaVenc = t.Translate('LB_FechaVenc','Fecha Venc.')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Estado 	= t.Translate('LB_Estado','Estado','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset BTN_Filtrar 	= t.Translate('BTN_Filtrar','Filtrar','/sif/generales.xml')>
<cfset LB_Cesion = t.Translate('LB_Cesion','Cesionaria')>
<cfset LB_DocCes = t.Translate('LB_DocCes','Documento Cesión')>
<cfset LB_DescCes = t.Translate('LB_DescCes','Descripcion Cesión')>
<cfset LB_Solic = t.Translate('LB_Solic','Solicitante')>
<cfset LB_Aprob = t.Translate('LB_Aprob','Aprobador')>

<cfif isdefined("form.btnConsultar") or isdefined("url.btnConsultar")>
   	       <cfset LvarfSNcodigo="">
		   <cfif isdefined('form.fSNcodigo') and len(trim(#form.fSNcodigo#)) gt 0>
		       <cfset LvarfSNcodigo= #form.fSNcodigo#>
		   <cfelseif isdefined('url.fSNcodigo') and len(trim(#url.fSNcodigo#)) gt 0>   
			    <cfset LvarfSNcodigo= #url.fSNcodigo#>
		   </cfif>
   		   
		   <cfset LvarfSNcodigo2="">
		   <cfif isdefined('form.fSNcodigo2') and len(trim(#form.fSNcodigo2#)) gt 0>
		       <cfset LvarfSNcodigo2= #form.fSNcodigo2#>
		   <cfelseif isdefined('url.fSNcodigo2') and len(trim(#url.fSNcodigo2#)) gt 0>   
			    <cfset LvarfSNcodigo2= #url.fSNcodigo2#>
		   </cfif>
		   
		   <cfset LvarFechaIni = "">
		   <cfif isdefined('form.FechaIni') and len(trim(#form.FechaIni#)) gt 0>
		       <cfset LvarFechaIni = #form.FechaIni#>
		   <cfelseif isdefined('url.FechaIni') and len(trim(#url.FechaIni#)) gt 0> 
		       <cfset LvarFechaIni = #url.FechaIni#>
		   </cfif>
		   
		   <cfset LvarFechaFin ="">
		   <cfif isdefined('form.FechaFin') and len(trim(#form.FechaFin#)) gt 0 >
		      <cfset LvarFechaFin = #form.FechaFin#> 
		   <cfelseif isdefined('url.FechaFin') and len(trim(#url.FechaFin#)) gt 0>  	  
		      <cfset LvarFechaFin = #url.FechaFin#> 
		   </cfif>
		   
		   <cfset LvarTipoDoc ="">
   		   <cfif isdefined('form.TipoDoc') and len(trim(#form.TipoDoc#)) gt 0 >
		      <cfset LvarTipoDoc = #form.TipoDoc#>
		   <cfelseif isdefined('url.TipoDoc') and len(trim(#url.TipoDoc#)) gt 0 >  
		      <cfset LvarTipoDoc = #url.TipoDoc#>
		   </cfif>
		   <cfset LvarbtnConsultar ="">
		   <cfif isdefined('form.btnConsultar') and len(trim(#form.btnConsultar#)) gt 0 >
		      <cfset LvarbtnConsultar = #form.btnConsultar#>
		   <cfelseif isdefined('url.btnConsultar') and len(trim(#url.btnConsultar#)) gt 0 > 	  
		      <cfset LvarbtnConsultar = #url.btnConsultar#>
		   </cfif>

<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfoutput>
<cfquery datasource="#session.dsn#" name="lista" maxrows="1001">
	select
			c.CPCid,
			case c.CPCtipo
				when 'M' then 1 else 2
			end as Orden,
			case c.CPCtipo
				when 'M' then '#Lbl_Multa#'
				when 'E' then '#Lbl_Embargo#'
				when 'C' then '#Lbl_Cesion#'
			end as Tipo,
			c.CPCdocumento as CPCdocumen,
			'           '#_Cat# c.CPCdescripcion as CPCdescrip,
			c.CPCfecha,
			sno.SNnombre as SNorigen,
			case c.CPCnivel
				when 'S' then ''
				when 'O' then 'OC:'		#_Cat# (select <cf_dbfunction name="to_char" args="EOnumero" datasource="#session.dsn#"> from EOrdenCM where EOidorden = c.EOidorden)
				when 'D' then 'CxP:'	#_Cat# (select CPTcodigo #_Cat# '-' #_Cat# Ddocumento from HEDocumentosCP where IDdocumento = c.IDdocumento)
			end as DOC,
			snd.SNnombre as SNdestino,
			m.Miso4217,
			usua.Usulogin as solicita,
			usuari.Usulogin as aprobador,
			UsucodigoAprueba,
			c.CPCmonto,
			c.CPCmonto - c.CPCpagado as Saldo,
			c.CPCmonto - c.CPCpagado - c.TESDPaprobadoPendiente as SaldoNeto,
			case c.CPCestado
				when 0 then 	'#Lbl_EnPrep#'
				when 1 then 	'#Lbl_EnApr#'
				when 2 then 	'#Lbl_Pendien#'
				when 3 then 	'#Lbl_Aprob#'
				when 4 then 	'#Lbl_Rechaz#'
				when 5 then 	'#Lbl_Anulado#'
				when 10 then 	'#Lbl_Pagado#'
			end as estado
	from	CPCesion c
		inner join SNegocios sno
			on sno.SNid = c.SNidOrigen
		left join SNegocios snd
			on snd.SNid = c.SNidDestino
		inner join Monedas m
			 on m.Ecodigo = c.Ecodigo
			and m.Mcodigo = c.Mcodigo
		inner join Usuario usua
			on c.UsucodigoSolicita=	usua.Usucodigo
		inner join Usuario usuari
			on c.UsucodigoAprueba=	usuari.Usucodigo
	where c.Ecodigo = #session.Ecodigo#
		<!----Tipo de Docuemento---->
		<cfif LvarTipoDoc EQ "C">
		  and c.CPCtipo = 'C'	  
		<cfelseif LvarTipoDoc EQ "E">
		  and c.CPCtipo = 'E'
		<cfelseif LvarTipoDoc EQ "M">
		  and c.CPCtipo = 'M'	
		</cfif>
	
	    <!----Fechas ----->
		<cfif len(trim(LvarFechaIni)) and len(trim(LvarFechaFin))>
			<cfif DateDiff("d", "#LvarFechaIni#", "#LvarFechaFin#")>
				and c.CPCfecha  between #lsparsedatetime(LvarFechaIni)# and #lsparsedatetime(LvarFechaFin)#
			<cfelse>
				and c.CPCfecha  between #lsparsedatetime(LvarFechaFin)# and  #lsparsedatetime(LvarFechaIni)#
			</cfif>		
		</cfif>
		<cfif len(trim(LvarFechaIni)) and not len(trim(LvarFechaFin))>
			and c.CPCfecha >= #lsparsedatetime(LvarFechaIni)#
		</cfif>
		<cfif not len(trim(LvarFechaIni)) and len(trim(LvarFechaFin))>
			and c.CPCfecha <= #lsparsedatetime(LvarFechaFin)#
		</cfif>

	  <!----Socios Negocio------>
	  		<cfif len(trim(LvarfSNcodigo)) and len(trim(LvarfSNcodigo2))>

			<cfif #LvarfSNcodigo# gt #LvarfSNcodigo2#>
				and sno.SNcodigo  between #LvarfSNcodigo2# and #LvarfSNcodigo#
			<cfelse>
				and sno.SNcodigo  between #LvarfSNcodigo# and  #LvarfSNcodigo2#
			</cfif>		
		</cfif>

		<cfif len(trim(LvarfSNcodigo)) and not len(trim(LvarfSNcodigo2))>
			and sno.SNcodigo = #LvarfSNcodigo#
		</cfif>
		<cfif  not len(trim(LvarfSNcodigo)) and len(trim(LvarfSNcodigo2))>
			and sno.SNcodigo = #LvarfSNcodigo2#
		</cfif>
 
	order by sno.SNnombre, Orden, CPCfecha, CPCid
</cfquery>
</cfoutput>
<cf_templateheader title="#Msg_ConsMEC#">
<cfoutput>
<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr><td colspan="2" align="center" style="font:bold; padding:4px;" bgcolor="##CCCCCC"><h2>#Msg_ConsMEC#</h2></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="8" align="right">		
        	<!---<cfset params = "?fSNcodigo=#LvarfSNcodigo#&fSNcodigo2=#LvarfSNcodigo2#&FechaIni=#LvarFechaIni#&FechaFin=#LvarFechaFin#&TipoDoc=#LvarTipoDoc#&btnConsultar=#form.btnConsultar#">--->
            <cfset params = "?fSNcodigo=#LvarfSNcodigo#&fSNcodigo2=#LvarfSNcodigo2#&FechaIni=#LvarFechaIni#&FechaFin=#LvarFechaFin#&TipoDoc=#LvarTipoDoc#&btnConsultar=#LvarbtnConsultar#">
			<cf_rhimprime datos="/sif/cp/consultas/ConsDocumentos-reporte.cfm" paramsuri="#params#">
			<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
		</td>
	</tr>
		<cfif isdefined("LvarbtnConsultar") and lista.RecordCount LT 1001>
			<cfif lista.RecordCount GT 0>
				<tr>
					<td colspan="2">
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pLista"
							query="#lista#"
							desplegar="Tipo, DOC,  CPCfecha, CPCfecha, Miso4217, CPCmonto,Saldo, estado,CPCdocumen,CPCdescrip,SNdestino,solicita,aprobador"
							etiquetas="#Lbl_TipoTran#, #LB_Documento#, #LB_FechaDoc#,#LB_FechaVenc#, #LB_Moneda#, #LB_Monto#, #LB_Saldo#, #LB_Estado#,#LB_DocCes#,#LB_DescCes#,#LB_Cesion#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;,#LB_Solic#,&nbsp;&nbsp;#LB_Aprob#"
							formatos="S, S,  D, D, S, M,M, S,S,S,S,S,S"
							align="left, left,  center, center, center, right,right, right,right,right,right,center,center"
							showlink="false"
							Cortes="SNorigen"
							maxrows="0"
							pageindex=""/>  
					</td>					
				</tr>
				<tr><td>&nbsp;</td></tr>
                <cfset Msg_FinCons = t.Translate('Msg_FinCons','Fin de la Consulta')>
				<tr valign="top" align="center"><td colspan="2">***************************** #Msg_FinCons# ***************************** </td></tr>
			<cfelse>
				<tr valign="top" align="center"> 
					<td colspan="2"   bgcolor="##CCCCCC" align="center">
                    	<cfset Msg_SinDatRel = t.Translate('Msg_SinDatRel','No hay datos relacionados')>
						<span style="font-size: 16px"><strong>*** #Msg_SinDatRel# ***</strong></span>
					</td>
				</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
		<cfelseif isdefined('lista') and lista.RecordCount GTE 1001> 
			<tr valign="top" align="center"> 
				<td colspan="2"   bgcolor="##CCCCCC" align="center">
                   	<cfset Msg_NumDocRes = t.Translate('Msg_NumDocRes','El n&uacute;mero de Documentos Resultantes')>
                   	<cfset Msg_ExcLimPer = t.Translate('Msg_ExcLimPer','en la consulta exceden el l&iacute;mite permitido. Delimite la consulta con filtros m&aacute;s detallados.')>
					<span style="font-size: 16px"><strong>*** #Msg_NumDocRes# *** <br>
					*** #Msg_ExcLimPer# ***</strong></span>
				</td>
			</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="5">
			<form style="margin:0;" action="ConsDocumentos.cfm" method="post">
				<cfoutput>
 				<input type="hidden" name="CPTcodigo" value="<cfif isdefined('url.CPTcodigo')>#url.CPTcodigo#</cfif>" />
				<input type="hidden" name="Documento" value="<cfif isdefined('url.Documento')>#url.Documento#</cfif>" />
				<input type="hidden" name="FechaFin" value="<cfif isdefined('url.FechaFin')>#url.FechaFin#</cfif>" />
				<input type="hidden" name="FechaIni" value="<cfif isdefined('url.FechaIni')>#url.FechaIni#</cfif>" />
				<input type="hidden" name="SNcodigo" value="<cfif isdefined('url.fSNcodigo')>#url.fSNcodigo#</cfif>" />
				<input type="hidden" name="SNnumero" value="<cfif isdefined('url.fSNnumero')>#url.fSNnumero#</cfif>" />
				<input type="hidden" name="SNcodigo2" value="<cfif isdefined('url.fSNcodigo2')>c.SNidDestino</cfif>" />
				<input type="hidden" name="btnConsultar" value="Consultar" />
				</cfoutput>
				<cf_botones exclude="Alta,Limpiar" include="Regresar">		
			</form>
		</td></tr>
	</table>
</cfoutput>    	
<cf_templatefooter >
</cfif>
