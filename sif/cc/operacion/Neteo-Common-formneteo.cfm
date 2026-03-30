<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 23 de agosto del 2005
	Motivo: Correccion del titulo de la forma, cuando entraba por CxP dejaba el titulo "Cuentas por Cobrar".
			Esto porque solo existen un proceso de neteo de documentos y este se encuentra dentro de la carpeta 
			de CxC. Creando un archivo dentro de CxP y haciendo la llamada del proceso, hace la corrección. Además 
			cambios en la seguridad de CxP.
			Se cambia la direccion de ubicacion de las distintas llamadas a fuentes condicionado a el modulo en q me encuentro. 
			Utilizando la variable de session modulo.
	Modificado por Gustavo Fonseca Hernández.
		Fecha 8-9-2005.
		Motivo: Se crea la función "funcBajaneteo" para que no valide el formulario en modo Baja y pregunta si Dmonto viene vacio.
	
	Modificado por: Ana Villavicencio
	Fecha: 12 de octubre del 2005
	Motivo: Se acomodaron las etiquetas de los campos del encabezado.
			
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_DigFecDocto = t.Translate('MSG_DigFecDocto','Hay una mezcla de Tipos de Documento incorrecta')>
<cfset LB_TpoNet = t.Translate('LB_TpoNet','Tipo de Neteo')>
<cfset MSG_NetDoctos = t.Translate('MSG_NetDoctos','Neteo de Documentos de CxC y CxP (Sin Anticipos de Efectivo)')>
<cfset MSG_AplAntCXC = t.Translate('MSG_AplAntCXC','Aplicación de Anticipos de CxC')>
<cfset MSG_AplAntCXP = t.Translate('MSG_AplAntCXP','Aplicación de Anticipos de CxP')>
<cfset MSG_NetAnt = t.Translate('MSG_NetAnt','Neteo de Anticipos de CxC y CxP (Sin Documentos a Aplicar)')>
<cfset MSG_NetNImpl = t.Translate('MSG_NetNImpl','Tipo de Neteo no se ha implementado)')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>   
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset Oficina 		= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Diferencia = t.Translate('LB_Diferencia','Diferencia')>   
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Obs = t.Translate('LB_Obs','Observaciones')> 
<cfset MSG_Aplicar = t.Translate('MSG_Aplicar','Desea Aplicar el Documento de Neteo de Documento?')>
<cfset MSG_DocSD = t.Translate('MSG_DocSD','El Documento no tiene detalles.')>
<cfset MSG_DocNoB = t.Translate('MSG_DocNoB','El Documento no est&aacute; balanceado.')>

<cfif isdefined("url.Fecha_F")  and LEN(TRIM(url.Fecha_F)) and not isdefined('form.Fecha_F')>
	<cfset form.Fecha_F= url.Fecha_F>
</cfif>
<cfif isdefined("url.DocumentoNeteo_F") and LEN(TRIM(url.DocumentoNeteo_F)) and not isdefined('form.DcouemtoNeteo_F')>
	<cfset form.DocumentoNeteo_F= url.DocumentoNeteo_F>
</cfif>
<cfif isdefined("url.SNcodigo_F") and len(trim(url.SNcodigo_F)) and not isdefined('form.SNcodigo_F')>
	<cfset form.SNcodigo_F=url.SNcodigo_F>
</cfif>

<cfset regresar = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset regresar = regresar & "Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocumentoNeteo_F") and LEN(TRIM(form.DocumentoNeteo_F))>
	<cfset regresar = regresar & "&DocumentoNeteo_F=#form.DocumentoNeteo_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset regresar = regresar & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>

<!--- Establezco el modoneteo --->
<cfset modoneteo = "ALTA">
<cfif isdefined("form.idDocumentoNeteo") and len(trim(form.idDocumentoNeteo)) and not isdefined("form.BtnNuevo")>
	<cfset modoneteo = "CAMBIO">
</cfif>

<!--- Obtiene Las Transacciones --->
<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, 
	       CCTdescripcion
	from CCTransacciones
	where Ecodigo = #session.Ecodigo#
	and CCTtranneteo = 1
	order by 1
</cfquery>

<!--- Obtiene Las Oficinas --->
<cfquery name="rsOficinas" datasource="#session.dsn#">
	select Ocodigo, 
	       Odescripcion
	from Oficinas
	where Ecodigo = #session.Ecodigo#
	order by 1
</cfquery>

<!--- Obtiene los datos del Documento de Neteo cuando el modoneteo es Cambio --->
<cfif (modoneteo neq "ALTA")>
	<cfquery name="rsDocumentoNeteo" datasource="#session.dsn#">
		select a.idDocumentoNeteo, a.Mcodigo, a.CCTcodigo, a.DocumentoNeteo, 
			a.Observaciones, a.SNcodigo, d.SNid, a.Dmonto, a.Ocodigo, 
			a.Dfechadoc, a.ts_rversion, b.Mnombre, c.CCTdescripcion,
			d.SNnombre,
			a.TipoNeteoDocs
		from DocumentoNeteo a
			inner join Monedas b
				on a.Mcodigo = b.Mcodigo
				and a.Ecodigo = b.Ecodigo
			left outer join CCTransacciones c
				on a.CCTcodigo = c.CCTcodigo
				and a.Ecodigo = c.Ecodigo
			left outer join SNegocios d
				on a.SNcodigo = d.SNcodigo
				and a.Ecodigo = d.Ecodigo
		where a.idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
		and a.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="rsTieneDetalles" datasource="#session.dsn#">
		select 
			coalesce(
				(
					select count(1)
					from DocumentoNeteoDCxC b
					where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
				)
			,0)
			
			+
			
			coalesce(
				(
					select count(1)
					from DocumentoNeteoDCxP b
					where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
				)
			,0) as cantidad,
			
			coalesce(	
				(
					select sum(a.Dmonto * case when b.CCTtipo = 'D' then 1 else -1 end)
					from DocumentoNeteoDCxC a, CCTransacciones b 
					where a.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
						and b.CCTcodigo = a.CCTcodigo 
						and b.Ecodigo = a.Ecodigo
				)
			, 0.00)
			
			+
			
			coalesce(	
				(
					select sum(a.Dmonto * case when b.CPTtipo = 'D' then 1 else -1 end)
					from DocumentoNeteoDCxP a, EDocumentosCP d, CPTransacciones b 
					where a.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
						and d.IDdocumento = a.idDocumento 
						and b.Ecodigo = d.Ecodigo
						and b.CPTcodigo = d.CPTcodigo
				)
			, 0.00) as saldo
			
		from DocumentoNeteo
		where Ecodigo = #session.Ecodigo#
		  and idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
	</cfquery>

	<cfset LvarTipoNeteoMSG = "">
	<cfset LvarTipoNeteoDocs = rsDocumentoNeteo.TipoNeteoDocs>
	<cfif LvarTipoNeteoDocs EQ 0>
		<cfset LvarTipoNeteoDocs = createobject("component","sif.Componentes.CC_AplicaDocumentoNeteo").DeterminarTipoNeteoDocs(form.idDocumentoNeteo)>
		<cfif LvarTipoNeteoDocs EQ -1>
			<cfset LvarTipoNeteoMSG = "#MSG_DigFecDocto#">
		</cfif>
	<cfelse>
		<cfset LvarTipoNeteoMSG = createobject("component","sif.Componentes.CC_AplicaDocumentoNeteo").VerificarTipoNeteoDocs(form.idDocumentoNeteo)>
	</cfif>
<cfelse>
	<cfset LvarTipoNeteoMSG = "">
	<cfset LvarTipoNeteoDocs = createobject("component","sif.Componentes.CC_AplicaDocumentoNeteo").DeterminarTipoNeteoDocs(-1)>
</cfif>

<cfoutput>
	<form action="Neteo-Common-sqlneteo.cfm" name="formneteo" method="post">
		<cfoutput>
			<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
				<input name="Fecha_F" type="hidden" value="#form.Fecha_F#" tabindex="-1">
			</cfif>
			<cfif isdefined("form.DocumentoNeteo_F") and LEN(TRIM(form.DocumentoNeteo_F))>
				<input name="DocumentoNeteo_F" type="hidden" value="#form.DocumentoNeteo_F#" tabindex="-1">
			</cfif>
			<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
				<input name="SNcodigo_F" type="hidden" value="#form.SNcodigo_F#" tabindex="-1">
			</cfif>
		</cfoutput>
		<table width="1%" align="center"  border="0" cellspacing="2" cellpadding="0">
			<tr><td colspan="4">&nbsp;</td></tr>
		<cfif LvarTipoNeteoDocs NEQ 0>
		  <tr>
			<td valign="top" nowrap align="right"><strong><cfoutput>#LB_TpoNet#&nbsp;:&nbsp;</cfoutput></strong></td>
			<td colspan="3">
				<cfif modoNeteo EQ "ALTA" OR rsTieneDetalles.cantidad EQ 0 OR LvarTipoNeteoMSG NEQ "">
					<cfif LvarTipoNeteoDocs EQ -1>
						<strong><font color="##FF0000">#LvarTipoNeteoMSG#</font></strong>
						<BR>
					</cfif>
				<select name="tipoNeteoDocs">
					<option value="1" <cfif LvarTipoNeteoDocs EQ 1>selected</cfif>>#MSG_NetDoctos#</option>
					<option value="2" <cfif LvarTipoNeteoDocs EQ 2>selected</cfif>>#MSG_AplAntCXC#</option>
					<option value="3" <cfif LvarTipoNeteoDocs EQ 3>selected</cfif>>#MSG_AplAntCXP#</option>
					<option value="4" <cfif LvarTipoNeteoDocs EQ 4>selected</cfif>>#MSG_NetAnt#</option>
				</select>
					<cfif LvarTipoNeteoMSG NEQ "" AND LvarTipoNeteoDocs NEQ -1>
						<BR>
						<strong><font color="##FF0000">#LvarTipoNeteoMSG#</font></strong>
					</cfif>
				<cfelse>
					<input type="hidden" name="tipoNeteoDocs" id="tipoNeteoDocs" value="#rsDocumentoNeteo.tipoNeteoDocs#">
					<cfif LvarTipoNeteoMSG NEQ "">
						<strong><font color="##FF0000">#LvarTipoNeteoMSG#</font></strong>
					<cfelseif LvarTipoNeteoDocs EQ 1>
						<strong>#MSG_NetDoctos#</strong>
					<cfelseif LvarTipoNeteoDocs EQ 2>
						<strong>#MSG_AplAntCXC#</strong>
					<cfelseif LvarTipoNeteoDocs EQ 3>
						<strong>#MSG_AplAntCXP#</strong>
					<cfelseif LvarTipoNeteoDocs EQ 4>
						<strong>#MSG_NetAnt#</strong>
					<cfelse>
						<cfthrow message="#MSG_NetNImpl#">
					</cfif>
				</cfif>	
			</td>
		  </tr>
		 </cfif>
		  <tr>
			<td valign="top" nowrap align="right"><strong>#LB_Documento#&nbsp;:&nbsp;</strong></td>
			<td>
				<input name="DocumentoNeteo" type="text" size="20" tabindex="1"
				 maxlength="20" <cfif isDefined("rsDocumentoNeteo.DocumentoNeteo")> value="#Trim(rsDocumentoNeteo.DocumentoNeteo)#" </cfif>>
			</td>
			<td valign="top" nowrap align="right"><strong>#LB_Fecha#&nbsp;:&nbsp;</strong></td>
			<td>
				<cfif (modoneteo neq "ALTA")>
					<cfset Lvar_fecha = rsDocumentoNeteo.Dfechadoc>
				<cfelse>
					<cfset Lvar_fecha = Now()>
				</cfif>
				<cf_sifcalendario form="formneteo" name="Dfechadoc" tabindex="1"
					value="#DateFormat(Lvar_fecha,'dd/mm/yyyy')#" >
			</td>	
		  </tr>
		  <tr>
			<td valign="top" nowrap align="right"><strong>#LB_Socio#&nbsp;:&nbsp;</strong></td>
			<td>
				<cfif isdefined("rsDocumentoNeteo.SNcodigo")>
					<cf_sifsociosnegocios2 form="formneteo" idquery="#rsDocumentoNeteo.SNcodigo#" size="43"  tabindex="1">
				<cfelse>
					<cf_sifsociosnegocios2 form="formneteo" size="43"  tabindex="1">
				</cfif>
			</td>
			<td valign="top" nowrap align="right"><p><strong>#Oficina#&nbsp;:&nbsp;</strong></p>    </td>
			<td>
				<select name="Ocodigo"  tabindex="1">
					<option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--seleccione una opci&oacute;n--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
					<cfloop query="rsOficinas">
						<option value="#rsOficinas.Ocodigo#" <cfif (isDefined("rsDocumentoNeteo.Ocodigo") AND rsOficinas.Ocodigo EQ rsDocumentoNeteo.Ocodigo)>selected</cfif>>#rsOficinas.Odescripcion#</option>
					</cfloop>
				</select>	
			</td>
		  </tr>
		  <tr>
			<td valign="top" nowrap align="right"><p><strong>#LB_Transaccion#&nbsp;:&nbsp;</strong></p>    </td>
			<td>
				<select name="CCTcodigo"  tabindex="1">
					<option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--seleccione una opci&oacute;n--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
					<cfloop query="rsTransacciones">
						<option value="#rsTransacciones.CCTcodigo#" <cfif (isDefined("rsDocumentoNeteo.CCTcodigo") AND rsTransacciones.CCTcodigo EQ rsDocumentoNeteo.CCTcodigo)>selected</cfif>>#rsTransacciones.CCTdescripcion#</option>
					</cfloop>
				</select>	
			</td>
			<td valign="top" nowrap align="right"><p><strong>#LB_Moneda#&nbsp;:&nbsp;</strong></p>    </td>
			<td>
				<cfif isdefined("rsDocumentoNeteo.Mcodigo") and rsTieneDetalles.cantidad GT 0>
					<!---  No se modifica en modoneteo cambio cuando tiene detalles porque todas las transacciones de cxc y cxp dependen de esta moneda --->
					<input type="hidden" name="Mcodigo" value="#rsDocumentoNeteo.Mcodigo#" tabindex="-1">
					#rsDocumentoNeteo.Mnombre#
				<cfelseif isdefined("rsDocumentoNeteo.Mcodigo")>
					<cf_sifmonedas form="formneteo" query="#rsDocumentoNeteo#"  tabindex="1">
				<cfelse>
					<cf_sifmonedas form="formneteo"  tabindex="1">
				</cfif>
			</td>			
		  </tr>
		  <tr>
			<td valign="top" nowrap align="right"><strong><cfif TipoNeteo eq 1>#LB_Diferencia#<cfelse>#LB_Monto#</cfif> : </strong></td>
			<td colspan="3">
				<cfif isDefined('rsDocumentoNeteo.Dmonto') and len(trim(rsDocumentoNeteo.Dmonto))>
					<cfset Lvar_monto = rsDocumentoNeteo.Dmonto>
				<cfelse>
					<cfset Lvar_monto = 0.00>
				</cfif>
				<cf_monto name="Dmonto" value="#Lvar_monto#" modificable="false"  tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td valign="top" nowrap align="right"><strong>#LB_Obs#&nbsp;:&nbsp;</strong></td>
			<td colspan="3">
				<textarea name="Observaciones" cols="85" rows="3"  tabindex="1"><cfif isDefined("rsDocumentoNeteo.Observaciones")>#Trim(rsDocumentoNeteo.Observaciones)#</cfif></textarea>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
		
		<!--- Validación para poner el botón de Aplicar --->
		<cfset Aplicar =  "">
		<cfif modoneteo neq "ALTA"
			and rsTieneDetalles.cantidad GT 0
			and (TipoNeteo eq 1 and rsTieneDetalles.saldo eq 0 or TipoNeteo neq 1)
			and LvarTipoNeteoMSG EQ "">
			<cfset Aplicar =  "Aplicar">
            <cfoutput>
			<script language="javascript" type="text/javascript">
				<!--//
				function funcAplicarneteo(){
					var result = true;
					if (confirm('#MSG_Aplicar#'))
						document.formneteo.action = "Neteo-Common-Aplicar.cfm";
					else
						result = false;
					return result;
				}
				//-->
			</script>
			</cfoutput>
		<cfelseif modoneteo neq "ALTA"
			and rsTieneDetalles.cantidad EQ 0>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td style="color:##FF0000" scope="col" align="center">#MSG_DocSD#</td>
				  </tr>
				</table>
		<cfelseif modoneteo neq "ALTA"
			and (TipoNeteo eq 1 and rsTieneDetalles.saldo NEQ 0)>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td style="color:##FF0000" scope="col" align="center">#MSG_DocNoB#</td>
				  </tr>
				</table>
		<cfelseif modoneteo neq "ALTA"
			and LvarTipoNeteoMSG NEQ "">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td style="color:##FF0000" scope="col" align="center">#LvarTipoNeteoMSG#</td>
				  </tr>
				</table>
		</cfif>
		<cf_botones formname="formneteo" sufijo="neteo" modo="#modoneteo#" include="#Aplicar#" regresar="../../#lcase(Session.monitoreo.smcodigo)#/operacion/Neteo-Lista#TipoNeteo#.cfm?#regresar#" tabindex="1">
		
		<cfif (modoneteo neq "ALTA")>
			<input type="hidden" name="idDocumentoNeteo" value="#rsDocumentoNeteo.idDocumentoNeteo#">
			<cfinvoke 
			component="sif.Componentes.DButils" 
			method="toTimeStamp" 
			returnvariable="ts" 
			arTimeStamp="#rsDocumentoNeteo.ts_rversion#"/>
			<input type="hidden" name="timestampneteo" value="#ts#">
		</cfif>
		<input type="hidden" name="TipoNeteo" value="#TipoNeteo#">
	</form>


<cf_qforms form="formneteo" >
            <cf_qformsRequiredField name="DocumentoNeteo" description="#LB_Documento#">
			<cf_qformsRequiredField name="SNcodigo" description="#LB_Socio#">
			<cf_qformsRequiredField name="Dfechadoc" description="#LB_Fecha#">
			<cf_qformsRequiredField name="Ocodigo" description="#Oficina#">
			<cf_qformsRequiredField name="CCTcodigo" description="#LB_Transaccion#">
			<cf_qformsRequiredField name="Mcodigo" description="#LB_Moneda#">
			<cf_qformsRequiredField name="Dmonto" description="#LB_Monto#">
</cf_qforms>
</cfoutput>