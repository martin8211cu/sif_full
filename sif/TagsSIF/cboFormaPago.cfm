<cfinvoke  key="LB_Pagarcon" default="Pagar con:" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Pagarcon" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="LB_SolPagarcon" default="Se Solicita Pagar con:" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_SolPagarcon" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="MSG_CambioFP" default="Ha sido cambiada la forma de pago. Debe cambiar el documento." component="sif.Componentes.Translate" method="Translate"
returnvariable="MSG_CambioFP" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="MSG_DiferentesFP" default="Hay asignadas diferentes formas de pago. Debe escoger una única forma de pago." component="sif.Componentes.Translate" method="Translate"
returnvariable="MSG_DiferentesFP" xmlfile="/sif/generales.xml"/>
<cfparam name="attributes.TESOPFPtipoId">
<cfparam name="attributes.TESOPFPid">
<cfparam name="attributes.TESOPFPtipo"	default="">
<cfparam name="attributes.TESOPFPcta" 	default="">
<cfparam name="attributes.SQL" 			default="">
<cfparam name="attributes.Ecodigo" 		default="#session.Ecodigo#">
<cfparam name="attributes.hiddenLabel" 	default="false">
<!--- Tipo documento : factura = 0, documento de remision = 1, etc--->
<cfparam name="attributes.tipoDocumento" default = "0">

<CFIF NOT ISDEFINED('FORM.TESOPFPtipo') AND ISDEFINED('Attributes.TESOPFPtipo')>
	<CFSET FORM.TESOPFPtipo = Attributes.TESOPFPtipo>
</CFIF>
<CFIF NOT ISDEFINED('FORM.TESOPFPcta_TEF') AND ISDEFINED('Attributes.TESOPFPcta')>
	<CFSET form.TESOPFPcta_TEF = Attributes.TESOPFPcta>
</CFIF>

<cfif attributes.SQL NEQ "">
	<cfif lcase(attributes.SQL) EQ "aplicacion">
		<cfset SQLaplicacion()>
	<cfelse>
		<cfset attributes.SQL = "">
		<cfset SQLactualiza()>
	</cfif>
	<cfexit>
</cfif>
<cfset LvarDatos = fnDatos(false,attributes.Ecodigo)>
<cfif LvarDatos EQ -1>
	<!--- No se envió TESOPFPtipoId o no hay tesorería --->
	<td>
		<input type="hidden" name="TESOPFPtipo"	value="">
		<input type="hidden" name="TESOPFPcta_TEF"	value="">
	</td>
	<!---<input type="hidden" name="TESOPFPcta_TCE"	value="">--->
<cfelseif attributes.TESOPFPtipoId EQ 6>
	<cfif LvarDatos EQ 0>
		<td>
			<input type="hidden" name="TESOPFPtipo"	value="">
			<input type="hidden" name="TESOPFPcta_TEF"	value="">
		</td>
		<cfreturn>
	</cfif>
	<td align="right">
		<strong><font color="#FF0000"><cfoutput>#LB_SolPagarcon#</cfoutput></font></strong>&nbsp;
	</td>
	<td nowrap colspan="10">
	<cfif LvarAnteriorUnico>
		<cfoutput>
		<strong>#rsFP_anteriores.destino#</strong>
		</cfoutput>
	<cfelse>
		<select>
		<cfoutput query="rsFP_anteriores">
			<option>
				#rsFP_anteriores.tipoDoc# #rsFP_anteriores.doc# - #rsFP_anteriores.destino#
			</option>
		</cfoutput>
		</select>
	</cfif>
	</td>
<cfelseif LvarDatos EQ 0>
	<cfif NOT attributes.hiddenLabel>
		<td align="right">
		<strong><cfoutput>#LB_Pagarcon#</cfoutput></strong>&nbsp;
		</td>
	</cfif>
	<td nowrap colspan="10">
	<!--- No hay anteriores --->
	<select name="TESOPFPtipo" id="TESOPFPtipo" onchange="fnFP_change()">
		<option value="">Default</option>
		<cfif LvarDatos LTE 0>
			<option value="1" <cfif rsFP_actual.TESOPFPtipo EQ "1">selected</cfif>>Cheque</option>
			<option value="2" <cfif rsCtasDstTR.recordCount EQ 0>disabled<cfelseif rsFP_actual.TESOPFPtipo EQ "2">selected</cfif>>TEF</option>
			<option value="3" <cfif rsFP_actual.TESOPFPtipo EQ "3">selected</cfif>>TCE</option>
			<option value="4" <cfif rsFP_actual.TESOPFPtipo EQ "4">selected</cfif>>ACH</option>
		</cfif>
	</select>
	&nbsp;
	<span id="TD_FP_TEF" style="display:none">
	<strong>Cuenta Destino:</strong>
	<select name="TESOPFPcta_TEF" id="TESOPFPcta_TEF" tabindex="1">
		<cfif rsCtasDstTR.recordCount EQ 0>
			<option value="">(No hay Cuentas Destino Registradas)</option>
		<cfelse>
			<!---<option value="">(Escoja una Cuenta Destino)</option>--->
			<cfoutput query="rsCtasDstTR">
			<option value="<cfif rsCtasDstTR.TESTPestado NEQ "2">#rsCtasDstTR.TESTPid#</cfif>" 
				<cfif rsFP_actual.TESOPFPtipo EQ "2" AND rsFP_actual.TESOPFPcta EQ rsCtasDstTR.TESTPid>selected</cfif>
			>#rsCtasDstTR.TESTPbanco# - #rsCtasDstTR.Miso4217# - #rsCtasDstTR.TESTPcuenta#<cfif rsCtasDstTR.TESTPestado EQ "2"> (Cta.Borrada)</cfif></option>
			</cfoutput>
		</cfif>
	</select>
	</span>
	<span id="TD_FP_TCE" style="display:none">
	<strong>Tarjeta de Crédito Empresarial</strong>
<!---
	<input name="TESOPFPcta_TCE" id="TESOPFPcta_TCE" tabindex="1" 
		<cfif rsFP_actual.TESOPFPtipo EQ "3">
		value="<cfoutput>#rsFP_actual.TESOPFPcta#</cfoutput>"
		</cfif>
	/>
--->
	</span>
		<span id="TD_FP_ACH" style="display:none">
	<strong>Tarjeta de Crédito Empresarial</strong>
<!---
	<input name="TESOPFPcta_TCE" id="TESOPFPcta_TCE" tabindex="1" 
		<cfif rsFP_actual.TESOPFPtipo EQ "3">
		value="<cfoutput>#rsFP_actual.TESOPFPcta#</cfoutput>"
		</cfif>
	/>
--->
	</span>
	<cfoutput>
	<script language="javascript">
		function fnFP_change()
		{
			var o = document.getElementById("TESOPFPtipo");
			if (o.value == "2")
			{
				document.getElementById("TD_FP_TEF").style.display = "";
				document.getElementById("TD_FP_TCE").style.display = "none";
			}
			else if (o.value == "3")
			{
				document.getElementById("TD_FP_TEF").style.display = "none";
				document.getElementById("TD_FP_TCE").style.display = "";
			}
			else
			{
				document.getElementById("TD_FP_TEF").style.display = "none";
				document.getElementById("TD_FP_TCE").style.display = "none";
			}
		}
		function habilitar_TESOPFP()
		{
			var o = document.getElementById("TESOPFPtipo");
			objForm.TESOPFPcta_TEF.description = "Cuenta Destino";
			<!---objForm.TESOPFPcta_TCE.description = "Tarjeta Crédito";--->
			if (o.value == "2")
			{
				objForm.TESOPFPcta_TEF.required = true;
				<!---objForm.TESOPFPcta_TCE.required = false;--->
			}
			else if (o.value == "3")
			{
				objForm.TESOPFPcta_TEF.required = false;
				<!---objForm.TESOPFPcta_TCE.required = true;--->
			}
			else
			{
				objForm.TESOPFPcta_TEF.required = false;
				<!---objForm.TESOPFPcta_TCE.required = false;--->
			}
		}
		function deshabilitar_TESOPFP()
		{
			objForm.TESOPFPcta_TEF.required = false;
			<!---objForm.TESOPFPcta_TCE.required = false;--->
		}
		function fnAplicar_TESOPFP(msg)
		{
			<cfif rsFP_actual.TESOPFPtipo EQ 0>
				<cfset LvarFormaPagoDB = "">
			<cfelse>
				<cfset LvarFormaPagoDB = rsFP_actual.TESOPFPtipo>
			</cfif>
			
			var o		= document.getElementById("TESOPFPtipo");
			var c		= document.getElementById("TESOPFPcta_TEF");
			var m1	= "#MSG_CambioFP#\n";
			
			
			if ((o.value != "#rsFP_actual.TESOPFPtipo#") || ((o.value == 2) && (c.value != "#rsFP_actual.TESOPFPcta#")))
			
			{
				error = true;
				if (msg)
					return m1;
				alert (m1);
				o.focus();
				return false;
			}
			if (msg)
				return "";
			return true;
		}
		fnFP_change();
	</script>
	</cfoutput>
	</td>
<cfelse>
	<!--- Sí hay anteriores --->
	<td align="right">
		<strong>Pagar con:</strong>&nbsp;
	</td>
	<td nowrap colspan="10">
	<cfset LvarSelected = false>
	<select name="TESOPFPtipo1" id="TESOPFPtipo1" onchange="fnFP_change()">
	<cfset LvarNA = true>
	<cfif NOT LvarAnteriorUnico>
		<option value="|">(Escoja una única forma de Pago)</option>
	</cfif>

	<cfoutput query="rsFP_anteriores">
		<option value="#rsFP_anteriores.TESOPFPtipo#|#rsFP_anteriores.TESOPFPcta#"
			<cfif NOT LvarSelected and rsFP_actual.TESOPFPtipo EQ rsFP_anteriores.TESOPFPtipo AND rsFP_actual.TESOPFPcta EQ rsFP_anteriores.TESOPFPcta>selected<cfset LvarSelected = true></cfif>
		>
			#rsFP_anteriores.tipoDoc# #rsFP_anteriores.doc# - #rsFP_anteriores.destino#
		</option>
		<cfif rsFP_anteriores.TESOPFPtipo EQ 0>
			<cfset LvarNA = false>
		</cfif>
	</cfoutput>
	<cfif LvarNA>
		<option value="0|"
			<cfif NOT LvarSelected and rsFP_actual.TESOPFPtipo EQ 0>selected<cfset LvarSelected = true></cfif>
		>Default</option>
	</cfif>
		
	</select>
	<cfoutput>
	<input type="hidden" name="TESOPFPtipo" 		id="TESOPFPtipo"	value="#rsFP_actual.TESOPFPtipo#">
	<cfif rsFP_actual.TESOPFPtipo EQ "2">
		<input type="hidden" name="TESOPFPcta_TEF"	id="TESOPFPcta_TEF"	value="#rsFP_actual.TESOPFPcta#">
		<!---<input type="hidden" name="TESOPFPcta_TCE"	id="TESOPFPcta_TCE"	value="">--->
	<cfelseif rsFP_actual.TESOPFPtipo EQ "3">
		<input type="hidden" name="TESOPFPcta_TEF"	id="TESOPFPcta_TEF"	value="">
		<!---<input type="hidden" name="TESOPFPcta_TCE"	id="TESOPFPcta_TCE"	value="#rsFP_actual.TESOPFPcta#">--->
	<cfelse>
		<input type="hidden" name="TESOPFPcta_TEF"	id="TESOPFPcta_TEF"	value="">
		<!---<input type="hidden" name="TESOPFPcta_TCE"	id="TESOPFPcta_TCE"	value="">--->
	</cfif>
	</cfoutput>
	<script language="javascript">
		function fnFP_change()
		{
			var o_tipo1	= document.getElementById("TESOPFPtipo1");
			var o		= document.getElementById("TESOPFPtipo");
			var o_TEF	= document.getElementById("TESOPFPcta_TEF");
			<!---var o_TCE	= document.getElementById("TESOPFPcta_TCE");--->
			var LvarArray = o_tipo1.value.split("|");
			o.value = LvarArray[0];
			if (LvarArray[0] == "0" || LvarArray[0] == "")
			{
				o.value = LvarArray[0];
				o_TEF.value = "";
				<!---o_TCE.value = "";--->
			}
			else if (LvarArray[0] == "2")
			{
				o.value = LvarArray[0];
				o_TEF.value = LvarArray[1];
				<!---o_TCE.value = "";--->
			}
			else if (LvarArray[0] == "3")
			{
				o.value = LvarArray[0];
				o_TEF.value = "";
				<!---o_TCE.value = LvarArray[1];--->
			}
			else
			{
				o.value = LvarArray[0];
				o_TEF.value = "";
				<!---o_TCE.value = "";--->
			}
		}

		function fnAplicar_TESOPFP(msg)
		{
			var o	= document.getElementById("TESOPFPtipo1");
			var m1	= "#MSG_CambioFP#\n";
			var m2	= "#MSG_DiferentesFP#\n";
		<cfif LvarAnteriorUnico AND rsFP_actual.TESOPFPtipo EQ "">
			<cfoutput>
			if (o.value == "0|")
			</cfoutput>
			{
				error = true;
				if (msg)
					return m1;
				alert (m1);
				o.focus();
				return false;
			}
		<cfelse>
			<cfoutput>
			if (o.value != "#rsFP_actual.TESOPFPtipo#|#rsFP_actual.TESOPFPcta#")
			</cfoutput>
			{
				error = true;
				if (msg)
					return m1;
				alert (m1);
				o.focus();
				return false;
			}
			if (o.value == "|")
			{
				error = true;
				if (msg)
					return m2;
				alert (m2);
				o.focus();
				return false;
			}
			if (msg)
				return "";
			return true;
		</cfif>
		}
		fnFP_change();
	</script>
	</td>
</cfif>

<cffunction name="fnDatos" returntype="numeric" output="false">
	<cfargument name="esAplicacion" default="false">
    <cfargument name="Ecodigo" required="no">
	
    <cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
    </cfif>
        
	<cfif attributes.TESOPFPid EQ "">
		<cfreturn -1>
	</cfif>

	<cfquery name="rsTES" datasource="#session.dsn#">
		Select e.TESid, t.EcodigoAdm
		  from TESempresas e
			inner join Tesoreria t
				on t.TESid = e.TESid
		 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	</cfquery>
	<cfif rsTES.recordCount EQ 0>
		<cfreturn -1>
	</cfif>
	<cfset session.Tesoreria.TESid = rsTES.TESid>
	<cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>

	<cfset LvarAnteriorUnico = false>
	<cfset LvarAnteriorDefault = false>
	<cf_dbfunction name="OP_concat" datasource="#session.dsn#" returnvariable="_CAT">
	<cfquery name="rsFP_actual" datasource="#session.dsn#">
		select TESOPFPtipo, TESOPFPcta,
				case coalesce(f.TESOPFPtipo,-1)
					when -1 then '(Escoja una única forma de Pago)'
					when 0  then 'Default'
					when 1  then 'Cheque'
					when 2  then 'TEF: ' #_CAT# (select TESTPbanco #_CAT# ' - ' #_CAT# Miso4217 #_CAT# ' - ' #_CAT# TESTPcuenta from TEStransferenciaP where TESTPid = f.TESOPFPcta)
					when 3  then 'Tarjeta Crédito'
					else 'Forma de Pago Desconocida'
				end destino
		  from TESOPformaPago f
		 where TESOPFPtipoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPtipoId#">
		   and TESOPFPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
	</cfquery>
	<cfif attributes.TESOPFPtipoId EQ "1">
		<!--- SC --->
		<!--- Documento Anterior:	Default --->
		<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
			select TESOPFPtipo, TESOPFPcta
			  from TESOPformaPago
			 where TESOPFPtipoId = 0
			   and TESOPFPid 	 = 0
		</cfquery>
		<cfif Arguments.esAplicacion>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfquery name="rsBeneficiario" datasource="#session.dsn#">
			select coalesce(sn.SNidCorporativo, sn.SNid) as SNid, 0 as TESBid, 0 as CDCcodigo
			  from ESolicitudCompraCM d
			  	inner join SNegocios sn
					 on sn.Ecodigo  = d.Ecodigo
					and sn.SNcodigo = d.SNcodigo
			 where d.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		</cfquery>
	<cfelseif attributes.TESOPFPtipoId EQ "2">
		<!--- OC --->
		<!--- Documento Anterior:	SC --->
		<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
			select distinct coalesce(TESOPFPtipo,0) as TESOPFPtipo, TESOPFPcta
			  from DOrdenCM d
				inner join DSolicitudCompraCM ant
				   on ant.DSlinea = d.DSlinea
				left join TESOPformaPago f
				   on f.TESOPFPtipoId	= 1	<!--- SC --->
				  and f.TESOPFPid 		= ant.ESidsolicitud
			 where d.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		</cfquery>
		<cfset LvarAnteriorUnico = rsFP_anteriores.recordCount EQ 1>
		<cfset LvarAnteriorDefault = LvarAnteriorUnico AND rsFP_anteriores.TESOPFPtipo EQ 0>
		<cfif Arguments.esAplicacion>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfif rsFP_anteriores.recordcount GT 0 AND NOT LvarAnteriorDefault>
			<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
				select distinct 'SC' as tipoDoc, ant.ESnumero as doc, coalesce(f.TESOPFPtipo,0) as TESOPFPtipo, f.TESOPFPcta,
                	case coalesce(f.TESOPFPtipo,0)
                    	when -1 then '(Escoja una única forma de Pago)'
                        when 0  then 'Default'
                        when 1  then 'Cheque'
                        when 2  then 'TEF: ' #_CAT# (select TESTPbanco #_CAT# ' - ' #_CAT# Miso4217 #_CAT# ' - ' #_CAT# TESTPcuenta from TEStransferenciaP where TESTPid = f.TESOPFPcta)
                        when 3  then 'TCE: Tarjeta Crédito'
                        else 'Forma de Pago Desconocida'
                    end destino
				  from DOrdenCM d
					inner join DSolicitudCompraCM ant
					   on ant.DSlinea = d.DSlinea
					 left join TESOPformaPago f
					   on f.TESOPFPtipoId	= 1	<!--- SC --->
					  and f.TESOPFPid 		= ant.ESidsolicitud
				 where d.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			</cfquery>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfquery name="rsBeneficiario" datasource="#session.dsn#">
			select coalesce(sn.SNidCorporativo, sn.SNid) as SNid
			  from EOrdenCM d
			  	inner join SNegocios sn
					 on sn.Ecodigo  = d.Ecodigo
					and sn.SNcodigo = d.SNcodigo
			 where d.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		</cfquery>
	<cfelseif attributes.TESOPFPtipoId EQ "3">
		<!--- Recepcion --->
		<!--- Documento Anterior:	OC --->
		<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
		</cfquery>
	<cfelseif attributes.TESOPFPtipoId EQ "4">
		<!--- CxP --->
		<!--- Documento Anterior:	3=Recepción y 2=OC --->
		<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
			select distinct coalesce(TESOPFPtipo,0) as TESOPFPtipo, TESOPFPcta
			  <cfif Attributes.tipoDocumento EQ "0">
					from DDocumentosCxP d
				<cfelseif Attributes.tipoDocumento EQ "1">
					from DDocumentosCPR d
				</cfif>
				inner join DOrdenCM ant
				   on ant.DOlinea = d.DOlinea
				left join TESOPformaPago f
				   on f.TESOPFPtipoId	= 2	<!--- OC --->
				  and f.TESOPFPid 		= ant.EOidorden
			 where d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		<!--- UNION Select from recepcion --->
		</cfquery>
		<cfset LvarAnteriorUnico = rsFP_anteriores.recordCount EQ 1>
		<cfset LvarAnteriorDefault = LvarAnteriorUnico AND rsFP_anteriores.TESOPFPtipo EQ 0>
		<cfif Arguments.esAplicacion>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfif rsFP_anteriores.recordcount GT 0 AND NOT LvarAnteriorDefault>
			<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
				select distinct 'OC' as tipoDoc, ant.EOnumero as doc, coalesce(f.TESOPFPtipo,0) as TESOPFPtipo, f.TESOPFPcta,
                	case coalesce(f.TESOPFPtipo,0)
                    	when -1 then '(Escoja una única forma de Pago)'
                        when 0  then 'Default'
                        when 1  then 'Cheque'
                        when 2  then 'TEF: ' #_CAT# (select TESTPbanco #_CAT# ' - ' #_CAT# Miso4217 #_CAT# ' - ' #_CAT# TESTPcuenta from TEStransferenciaP where TESTPid = f.TESOPFPcta)
                        when 3  then 'TCE: Tarjeta Crédito'
                        else 'Forma de Pago Desconocida'
                    end destino
				  <cfif Attributes.tipoDocumento EQ "0">
						from DDocumentosCxP d
					<cfelseif Attributes.tipoDocumento EQ "1">
						from DDocumentosCPR d
					</cfif>
					inner join DOrdenCM ant
					   on ant.DOlinea = d.DOlinea
					 left join TESOPformaPago f
					   on f.TESOPFPtipoId	= 2	<!--- OC --->
					  and f.TESOPFPid 		= ant.EOidorden
				 where d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			<!--- UNION Select from recepcion --->
			</cfquery>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfquery name="rsBeneficiario" datasource="#session.dsn#">
			select coalesce(sn.SNidCorporativo, sn.SNid) as SNid
			  <cfif Attributes.tipoDocumento EQ "0">
			      from EDocumentosCxP d
				<cfelseif Attributes.tipoDocumento EQ "1">
				    from EDocumentosCPR d
				</cfif>
			  	inner join SNegocios sn
					 on sn.Ecodigo  = d.Ecodigo
					and sn.SNcodigo = d.SNcodigo
			 where d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		</cfquery>
	<cfelseif attributes.TESOPFPtipoId EQ "5">
		<!--- SP --->
		<!--- Documento Anterior:	4=CxPs --->
		<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
			select distinct coalesce(TESOPFPtipo,0) as TESOPFPtipo, TESOPFPcta
			  from TESdetallePago d
				inner join DDocumentosCP ant
				   on d.TESDPtipoDocumento = 1
				  and ant.IDdocumento 		 = d.TESDPidDocumento
				left join TESOPformaPago f
				   on f.TESOPFPtipoId	= 4	<!--- CxP --->
				  and f.TESOPFPid 		= ant.IDdocumento
			 where d.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			   and d.TESDPtipoDocumento = 1
		</cfquery>
		<cfset LvarAnteriorUnico = rsFP_anteriores.recordCount EQ 1>
		<cfset LvarAnteriorDefault = LvarAnteriorUnico AND rsFP_anteriores.TESOPFPtipo EQ 0>
		<cfif Arguments.esAplicacion>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfif rsFP_anteriores.recordcount GT 0 AND NOT LvarAnteriorDefault>
			<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
				select distinct 'CxP' as tipoDoc, ant.CPTcodigo #_CAT# '-' #_CAT# ant.Ddocumento as doc, coalesce(f.TESOPFPtipo,0) as TESOPFPtipo, f.TESOPFPcta,
                	case coalesce(f.TESOPFPtipo,0)
                    	when -1 then '(Escoja una única forma de Pago)'
                        when 0  then 'Default'
                        when 1  then 'Cheque'
                        when 2  then 'TEF: ' #_CAT# (select TESTPbanco #_CAT# ' - ' #_CAT# Miso4217 #_CAT# ' - ' #_CAT# TESTPcuenta from TEStransferenciaP where TESTPid = f.TESOPFPcta)
                        when 3  then 'TCE: Tarjeta Crédito'
                        else 'Forma de Pago Desconocida'
                    end destino
				  from TESdetallePago d
					inner join DDocumentosCP ant
					   on ant.IDdocumento 		 = d.TESDPidDocumento
					 left join TESOPformaPago f
					   on f.TESOPFPtipoId	= 4	<!--- CxP --->
					  and f.TESOPFPid 		= ant.IDdocumento
				 where d.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
				   and d.TESDPtipoDocumento = 1
			</cfquery>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfquery name="rsBeneficiario" datasource="#session.dsn#">
			select 	(select coalesce(sn.SNidCorporativo, sn.SNid) from SNegocios sn where sn.Ecodigo = d.EcodigoOri and sn.SNcodigo = d.SNcodigoOri) 
					as SNid,
					TESBid,
					CDCcodigo
			  from TESsolicitudPago d
			 where d.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			   and d.TESSPtipoDocumento in (1,0,5)
		</cfquery>
	<cfelseif attributes.TESOPFPtipoId EQ "6">
		<!--- SP --->
		<!--- Documento Anterior:	4=SPs --->
		<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
			select distinct coalesce(TESOPFPtipo,0) as TESOPFPtipo, TESOPFPcta
			  from TESsolicitudPago ant
				left join TESOPformaPago f
				   on f.TESOPFPtipoId	= 5	<!--- SPs --->
				  and f.TESOPFPid 		= ant.TESSPid
			 where ant.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		</cfquery>
		<cfset LvarAnteriorUnico = rsFP_anteriores.recordCount EQ 1>
		<cfset LvarAnteriorDefault = LvarAnteriorUnico AND rsFP_anteriores.TESOPFPtipo EQ 0>
		<cfif Arguments.esAplicacion>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfif rsFP_anteriores.recordcount GT 0 AND NOT LvarAnteriorDefault>
			<cfquery name="rsFP_anteriores" datasource="#session.dsn#">
				select distinct 'SP' as tipoDoc, ant.TESSPnumero as doc, coalesce(f.TESOPFPtipo,0) as TESOPFPtipo, f.TESOPFPcta,
                	case coalesce(f.TESOPFPtipo,0)
                    	when -1 then '(Escoja una única forma de Pago)'
                        when 0  then 'Default'
                        when 1  then 'Cheque'
                        when 2  then 'TEF: ' #_CAT# (select TESTPbanco #_CAT# ' - ' #_CAT# Miso4217 #_CAT# ' - ' #_CAT# TESTPcuenta from TEStransferenciaP where TESTPid = f.TESOPFPcta)
                        when 3  then 'TCE: Tarjeta Crédito'
                        else 'Forma de Pago Desconocida'
                    end destino
			  from TESsolicitudPago ant
				left join TESOPformaPago f
				   on f.TESOPFPtipoId	= 5	<!--- SPs --->
				  and f.TESOPFPid 		= ant.TESSPid
			 where ant.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			</cfquery>
			<cfreturn rsFP_anteriores.recordcount>
		</cfif>
		<cfquery name="rsBeneficiario" datasource="#session.dsn#">
			select 	(select coalesce(sn.SNidCorporativo, sn.SNid) from SNegocios sn where sn.Ecodigo = d.EcodigoOri and sn.SNcodigo = d.SNcodigoOri) 
					as SNid,
					TESBid,
					CDCcodigo
			  from TESsolicitudPago d
			 where d.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			   and d.TESSPtipoDocumento in (1,0,5)
		</cfquery>
		<cfreturn 0>
	</cfif>

	<cfset validaActual()>

	<cfquery datasource="#session.dsn#" name="rsCtasDstTR">
		select TESTPid, TESTPbanco, Miso4217, TESTPcuenta, TESTPestado,
						Bid,
						TESTPcodigoTipo,
						TESTPcodigo,
						TESTPtipoCtaPropia
		  from TEStransferenciaP
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		 <cfif rsBeneficiario.SNid NEQ "">
		   and SNidP = #rsBeneficiario.SNid#
		 <cfelseif rsBeneficiario.TESBid NEQ "">
		   and TESBid = #rsBeneficiario.TESBid#
		 <cfelseif rsBeneficiario.CDCcodigo NEQ "">
		   and CDCcodigo = #rsBeneficiario.CDCcodigo#
		 <cfelse>
		   and SNidP = 0
		 </cfif>
		   and TESTPestado < 2
	</cfquery>

	<cfreturn 0>
</cffunction>

<cffunction name="SQLactualiza" returntype="void" output="false">
	<cfparam name="attributes.TESOPFPid" 	default="">
	<cfquery name="rsFP_actual" datasource="#session.dsn#">
		select TESOPFPtipo, TESOPFPcta
		  from TESOPformaPago
		 where TESOPFPtipoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPtipoId#">
		   and TESOPFPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
	</cfquery>

	<cfparam name="form.TESOPFPtipo" default="">
	<cfif form.TESOPFPtipo EQ "2">
		<cfif NOT ISDEFINED('form.TESOPFPcta_TEF') OR form.TESOPFPcta_TEF EQ "">
			<cfthrow message="Falta indicar Cuenta Destino">
		</cfif>
		<cfset LvarTESOPFPcta = TESOPFPcta_TEF>
	<cfelse>
		<cfset LvarTESOPFPcta = "">
	</cfif>

	<cfif rsFP_actual.TESOPFPtipo NEQ attributes.TESOPFPtipo OR rsFP_actual.TESOPFPcta NEQ LvarTESOPFPcta or lcase(attributes.SQL) EQ "delete">
		<cfquery datasource="#session.dsn#">
			delete from TESOPformaPago
			 where TESOPFPtipoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPtipoId#">
			   and TESOPFPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		</cfquery>
	</cfif>
	<cfif form.TESOPFPtipo EQ "" or lcase(attributes.SQL) EQ "delete">
		<cfreturn>
	</cfif>

	<cfquery datasource="#session.dsn#">
		insert into TESOPformaPago (TESOPFPtipoId, TESOPFPid, TESOPFPtipo, TESOPFPcta)
		 values (
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPtipoId#">
			,<cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPFPtipo#">
			,<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESOPFPcta#" null="#LvarTESOPFPcta EQ ""#">
		)
	</cfquery>
</cffunction>

<cffunction name="SQLaplicacion" returntype="void" output="false">
	<cfparam name="attributes.TESOPFPid" 	default="">

	<cfif fnDatos(true,attributes.Ecodigo) NEQ -1>
		<cfset validaActual(true)>
	</cfif>
</cffunction>

<cffunction name="validaActual" returntype="void" output="false">
	<cfargument name="esAplicacion" default="false">

	<!--- Elimina el actual Default cuando Es Aplicacion o No hay Anteriores --->
	<cfif rsFP_actual.TESOPFPtipo EQ 0 AND (Arguments.esAplicacion OR rsFP_Anteriores.recordCount EQ 0)>
		<cfquery datasource="#session.dsn#">
			delete from TESOPformaPago
			 where TESOPFPtipoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPtipoId#">
			   and TESOPFPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
		</cfquery>
		<cfreturn>
	<cfelseif rsFP_actual.TESOPFPtipo EQ "" AND rsFP_Anteriores.recordCount EQ 0>
		<cfreturn>
	</cfif>
	
	<!--- Elimina el actual cuando es inválido: cuando el Actual no esta en anteriores--->
	<cfif rsFP_Anteriores.recordCount GT 0 AND rsFP_actual.TESOPFPtipo NEQ "0" AND rsFP_actual.TESOPFPtipo NEQ "" AND NOT LvarAnteriorDefault>
		<cfquery name="rsSQL" dbtype="query">
			select TESOPFPtipo
			  from rsFP_anteriores
			 where TESOPFPtipo	= #rsFP_actual.TESOPFPtipo#
			<cfif rsFP_actual.TESOPFPtipo EQ "2">
			   and TESOPFPcta	= #rsFP_actual.TESOPFPcta#
			 </cfif>
		</cfquery>
		<cfif rsSQL.TESOPFPtipo NEQ rsFP_actual.TESOPFPtipo>
			<cfquery datasource="#session.dsn#">
				delete from TESOPformaPago
				 where TESOPFPtipoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPtipoId#">
				   and TESOPFPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
			</cfquery>
			<cfset rsFP_actual = querynew("TESOPFPtipo, TESOPFPcta")>
		</cfif>
	</cfif>
	
	<!--- Cuando no se ha escogido y es aplicacion: si hay mas de un anterior envia error, si no lo incluye --->
	<cfif rsFP_actual.TESOPFPtipo EQ "" AND Arguments.esAplicacion>
		<cfif NOT LvarAnteriorUnico AND rsFP_Anteriores.recordCount GT 0>
			<cfthrow message="#MSG_DiferentesFP#">
		</cfif>
	
		<cfif LvarAnteriorUnico>
			<cfquery datasource="#session.dsn#">
				insert into TESOPformaPago (TESOPFPtipoId, TESOPFPid, TESOPFPtipo, TESOPFPcta)
				 values (
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPtipoId#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.TESOPFPid#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFP_anteriores.TESOPFPtipo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFP_anteriores.TESOPFPcta#" null="#rsFP_anteriores.TESOPFPcta EQ ""#">
				)
			</cfquery>
		</cfif>
	</cfif>
</cffunction>
