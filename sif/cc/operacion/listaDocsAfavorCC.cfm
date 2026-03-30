<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Cambiar la clase del filtro para mantenga los estandares.

	Modificado por: Ana Villavicencio
	Fecha: 08 de diciembre del 2005
	Motivo: Cambio en la forma del despliegue de datos. 

	Modificado por Gustavo Fonseca H.
		Fecha: 22-9-2005.
		Motivo: Se agrega la navegación y el tratamiento de los campos del filtro para que se mantengan con la nevegación.
 --->
 <cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">

			<cfif isdefined("Url.PageNum_rsDocumentos") and not isdefined("Form.PageNum_rsDocumentos")>
				<cfparam name="Form.PageNum_rsDocumentos" default="#Url.PageNum_rsDocumentos#">
			</cfif>
            <cfparam name="form.PageNum_rsDocumentos" default="1">
			<cfif isdefined('form.Filtrar')>
				<cfset form.PageNum_rsDocumentos = 1 >
			</cfif>
            <cfparam name="PageNum_rsDocumentos" default="#form.PageNum_rsDocumentos#">			
			
			<cfif isdefined("url.Transaccion") and len(trim(url.Transaccion)) and not isdefined("form.Transaccion")>
				<cfset form.Transaccion = url.Transaccion>
			</cfif>
			<cfif isdefined("url.descripcion") and len(trim(url.descripcion)) and not isdefined("form.descripcion")>
				<cfset form.descripcion = url.descripcion>
			</cfif>
			<cfif isdefined("url.Fecha") and len(trim(url.Fecha)) and not isdefined("form.Fecha")>
				<cfset form.Fecha = url.Fecha>
			</cfif>
			<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and not isdefined("form.Moneda")>
				<cfset form.Moneda = url.Moneda>
			</cfif>
			<cfif isdefined("url.usuario") and len(trim(url.usuario)) and not isdefined("form.usuario")>
				<cfset form.usuario = url.usuario>
			</cfif>
  
            <cfquery name="rsfechas" datasource="#Session.DSN#">
				select distinct EFfecha
				from EFavor a
				where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>
            <cfquery name="CCTransacciones" datasource="#Session.DSN#">
			 	select distinct a.CCTcodigo, b.CCTdescripcion
                from EFavor a, CCTransacciones b 
                where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and a.Ecodigo 	= b.Ecodigo
                  and a.CCTcodigo 	= b.CCTcodigo
				  and b.CCTtipo     = 'C'
				  and coalesce(b.CCTpago,0) != 1
                order by a.CCTcodigo desc
            </cfquery>
            <cfquery name="rsUsuarios" datasource="#Session.DSN#">
				select distinct EFusuario 
                from EFavor
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                order by EFusuario desc 
            </cfquery>
            <cfquery name="rsMonedas" datasource="#Session.DSN#">
				select distinct a.Mcodigo, b.Mnombre as Mnombre
				from Monedas b , EFavor a 
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and b.Mcodigo = a.Mcodigo 
                  order by b.Mnombre desc 
			</cfquery>
     
            <cfif isDefined("Form.Aplicar") and isdefined("Form.chk")>
              <cfset chequeados = ListToArray(Form.chk, ',')>
              <cfset cuantos = ArrayLen(chequeados)>
              <cfloop index="CountVar" from="1" to="#cuantos#">
                <cfset valores = ListToArray(chequeados[CountVar],'|')>
			
				<!--- La fecha en EFavor no puede ser menor a la fecha del documento asociado en la tabla Documentos --->
				<cfquery name="rsValidaA" datasource="#session.DSN#">
					select 
						case when 
						(e.EFfecha) < (select d.Dfecha 
										from Documentos d 
										where d.Ecodigo = e.Ecodigo 
											and d.CCTcodigo = e.CCTcodigo
											and d.Ddocumento = e.Ddocumento)
						then 1 else 2 end as diferencia
					from EFavor e
					where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and e.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#valores[2]#">
						and e.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char"  value="#valores[3]#">
				</cfquery>
				<cfif isdefined("rsValidaA") and rsValidaA.diferencia eq 1>
					<cfset MSG_AplDoctoA = t.Translate('MSG_AplDoctoA','No se puede aplicar el Documento al ser la fecha del Encabezado menor a la fecha del Documento Relacionado.')>
					<cf_errorCode	code = "50175" msg = "#MSG_AplDoctoA#">
					<cfabort>
				</cfif>
				
				<!--- La fecha en EFavor no puede ser menor a la fecha del documento relacionado en la tabla Documentos via la tabla DFavor --->
				<cfquery name="rsValidaB" datasource="#session.DSN#">
					select 
						case when 
						(e.EFfecha) < (select d.Dfecha 
										from Documentos d 
										where d.Ecodigo = df.Ecodigo 
											and d.CCTcodigo = df.CCTRcodigo
											and d.Ddocumento = df.DRdocumento)
						then 1 else 2 end as diferencia
					from EFavor e
						inner join DFavor df
							on df.Ecodigo = e.Ecodigo
								and df.CCTcodigo = e.CCTcodigo
								and df.Ddocumento  = e.Ddocumento
					where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and e.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#valores[2]#">
						and e.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char"  value="#valores[3]#">
				</cfquery>
				<cfif isdefined("rsValidaB") and rsValidaB.diferencia eq 1>
					<cfset MSG_AplDoctoB = t.Translate('MSG_AplDoctoB','No se puede aplicar un Documento del detalle con fecha mayor a la Fecha del Encabezado.')>
					<cf_errorCode	code = "50176" msg = "#MSG_AplDoctoB#">
					<cfabort>
				</cfif>
				
				<!--- Invoca el componente de posteo --->
				<cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC"
				  method = "CC_PosteoDocsFavorCxC"
					Ecodigo    = "#Session.Ecodigo#"
					CCTcodigo  = "#valores[2]#"
					Ddocumento = "#valores[3]#"
					usuario    = "#Session.usuario#"
					Usucodigo  = "#Session.usucodigo#"
					fechaDoc   = "S"
					debug      = "NO"
					/>
              </cfloop>
            </cfif>
			<cfquery name="rsDocumentos" datasource="#Session.DSN#">
				select 	rtrim(EFavor.CCTcodigo) as CCTcodigo, 
						rtrim(EFavor.Ddocumento) as Ddocumento, 
						<cf_dbfunction name="concat" args="rtrim(EFavor.CCTcodigo),rtrim(EFavor.Ddocumento)"> as IDpago, 
						CCTransacciones.CCTdescripcion,  
						EFfecha, 
						Monedas.Mnombre, 
						EFtotal,
						(	select count(*) 
							from DFavor x 
							where EFavor.Ecodigo = x.Ecodigo 
							  and EFavor.CCTcodigo = x.CCTcodigo 
							  and EFavor.Ddocumento = x.Ddocumento) as Balance,
						(d.Dsaldo - EFavor.EFtotal) as Disponible

                from EFavor
					inner join Documentos d
						on d.Ecodigo = EFavor.Ecodigo
						and d.Ddocumento = EFavor.Ddocumento
						and d.CCTcodigo  = EFavor.CCTcodigo
						
					inner join Monedas
						on Monedas.Mcodigo			= EFavor.Mcodigo
					inner join CCTransacciones
						on CCTransacciones.CCTcodigo	= EFavor.CCTcodigo 
                    and CCTransacciones.Ecodigo	= EFavor.Ecodigo    

                where EFavor.Ecodigo			=  #Session.Ecodigo#
				  and CCTransacciones.CCTtipo = 'C'
				  and coalesce(CCTransacciones.CCTpago, 0) != 1

              	<cfif isdefined("Form.usuario") and len(trim(Form.usuario)) GT 0 and  Form.usuario NEQ -1>
					and upper(EFavor.EFusuario) like '%#Ucase(Form.usuario)#%'
	          	</cfif>
		 		<cfif isdefined("Form.descripcion") and len(trim(Form.descripcion)) GT 0 and Form.descripcion NEQ -1 >
	 				and ltrim(rtrim(upper(EFavor.Ddocumento))) like '%#Trim(Ucase(Form.descripcion))#%'
				</cfif>
	         	<cfif isdefined("Form.Transaccion") and Form.Transaccion NEQ -1>
    	      		and EFavor.CCTcodigo = '#Form.Transaccion#'
              	</cfif>
           		<cfif isdefined("Form.Fecha") and len(trim(Form.Fecha)) GT 0 and Form.Fecha NEQ -1>
                	and EFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.Fecha)#">
              	</cfif>				
           		<cfif isdefined("Form.Moneda") and len(trim(Form.Moneda)) GT 0 and Form.Moneda NEQ -1>
    	      		and EFavor.Mcodigo = #Form.Moneda#
              	</cfif>				
            </cfquery>

			<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
            <cfset MaxRows_rsDocumentos = 20 >

            <cfset StartRow_rsDocumentos=Min((PageNum_rsDocumentos-1)*MaxRows_rsDocumentos+1,Max(rsDocumentos.RecordCount,1))>
            <cfset EndRow_rsDocumentos=Min(StartRow_rsDocumentos+MaxRows_rsDocumentos-1,rsDocumentos.RecordCount)>
            <cfset TotalPages_rsDocumentos=Ceiling(rsDocumentos.RecordCount/MaxRows_rsDocumentos)>
            <cfset QueryString_rsDocumentos=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
            <cfset tempPos=ListContainsNoCase(QueryString_rsDocumentos,"PageNum_rsDocumentos=","&")>
            <cfif tempPos NEQ 0>
              <cfset QueryString_rsDocumentos=ListDeleteAt(QueryString_rsDocumentos,tempPos,"&")>
            </cfif>
			<cfset navegacion = "">
			<cfif isdefined("Form.Transaccion") and Len(Trim(Form.Transaccion)) NEQ 0>
				<cfset navegacion = navegacion & "&Transaccion=#Form.Transaccion#">
			</cfif>
			<cfif isdefined("Form.descripcion") and Len(Trim(Form.descripcion)) NEQ 0>
				<cfset navegacion = navegacion & "&descripcion=#Form.descripcion#">
			</cfif>
			<cfif isdefined("Form.Fecha") and Len(Trim(Form.Fecha)) NEQ 0>
				<cfset navegacion = navegacion & "&Fecha=#Form.Fecha#">
			</cfif>
			<cfif isdefined("Form.Moneda") and Len(Trim(Form.Moneda)) NEQ 0>
				<cfset navegacion = navegacion & "&Moneda=#Form.Moneda#">
			</cfif>
			<cfif isdefined("Form.usuario") and Len(Trim(Form.usuario)) NEQ 0>
				<cfset navegacion = navegacion & "&usuario=#Form.usuario#">
			</cfif>
            
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset LB_Titulo = t.Translate('LB_Titulo','Lista de Documentos a Favor sin Aplicar')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transaccion','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_USUARIO = t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Todas = t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset BTN_Aplicar = t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>
<cfset LB_Filtrar = t.Translate('LB_Filtrar','Filtrar','/sif/generales.xml')>
<cfset BTN_Nuevo = t.Translate('BTN_Nuevo','Nuevo','/sif/generales.xml')>
<cfset LB_Reporte = t.Translate('LB_Reporte','Reporte','/sif/generales.xml')>

<cf_templateheader title="#LB_TituloH#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>			
 			<form style="margin:0" action="listaDocsAfavorCC.cfm" method="post" name="form1">           
		      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
              	<cfoutput>
                <tr> 
                  <td width="2%">&nbsp;</td>
                  <td><strong>#LB_Transaccion#</strong></td>
                  <td><strong>#LB_Documento#</strong></td>
                  <td><strong>#LB_Fecha#</strong></td>
                  <td><strong>#LB_Moneda#</strong></td>
                  <td><strong>#LB_USUARIO#</strong></td>
                  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <cfif rsDocumentos.RecordCount>
				  <td>&nbsp;</td>
				  </cfif>
                </tr>
                </cfoutput>
                <tr> 
                  <td>&nbsp;</td>
                  <td>
                    <select name="Transaccion">
                      <option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
                      <cfoutput query="CCTransacciones"> 
                        <option value="#CCTransacciones.CCTcodigo#" <cfif isdefined ("form.Transaccion") and len(trim(form.Transaccion)) and form.Transaccion eq CCTransacciones.CCTcodigo>selected</cfif>>#CCTransacciones.CCTcodigo# - #CCTransacciones.CCTdescripcion#</option>
                      </cfoutput> 
                    </select>
                  </td>
                  <td>
                    <input name="descripcion" type="text" value="<cfif isdefined("form.descripcion") and len(trim(form.descripcion))><cfoutput>#trim(form.descripcion)#</cfoutput></cfif> " size="50" maxlength="50">
                  </td>
                  <td>
                    <select name="Fecha">
                      <option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
                      <cfoutput query="rsfechas"> 
                        <option value="#DateFormat(rsfechas.EFfecha,'dd/mm/yyyy')#" <cfif isdefined ("form.Fecha") and len(trim(form.Fecha)) and form.Fecha eq rsfechas.EFfecha>selected</cfif>>#DateFormat(rsfechas.EFfecha,'dd/mm/yyyy')#</option>
                      </cfoutput> 
                    </select>
                  </td>
                  <td>
                    <select name="Moneda">
                      <option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
                      <cfoutput query="rsMonedas"> 
                        <option value="#rsMonedas.Mcodigo#" <cfif isdefined ("form.Moneda") and len(trim(form.Moneda)) and form.Moneda eq rsMonedas.Mcodigo>selected</cfif>>#rsMonedas.Mnombre#</option>
                      </cfoutput> 
                    </select>
                  </td>
                  <td>
                    <select name="usuario">
                      <option value="-1"><cfoutput>#LB_Todos#</cfoutput></option>
                      <cfoutput query="rsUsuarios"> 
                        <option value="#rsUsuarios.EFusuario#" <cfif isdefined ("form.usuario") and len(trim(form.usuario)) and form.usuario eq rsUsuarios.EFusuario>selected</cfif>>#rsUsuarios.EFusuario#</option>
                      </cfoutput> 
                    </select>
                  </td>
				  <cfoutput>              
                  <td width="1%">
                    <input type="submit" name="Filtrar" value="#LB_Filtrar#">
				  </td>
				  <td width="1%">
				  	<input name="NuevoE" type="submit" value="#BTN_Nuevo#" onclick= "javascript:document.form1.action='AplicaDocsAfavorCC.cfm';">
				  </td>
				  <cfif rsDocumentos.RecordCount>
				  <td width="1%">
					<input name="Aplicar" type="submit" value="#BTN_Aplicar#" onclick= "return valida();">
				  </td>
				  </cfif>
				  <td width="1%">
				    <cfif rsDocumentos.RecordCount GT 0>
						<input name="Reporte" type="submit" id="Reporte" value="#LB_Reporte#" onClick="javascript: document.form1.method='get'; document.form1.action='../reportes/ReporteAplicaDoc.cfm'">
				  	</cfif>
				  </td>
				  </cfoutput>                   
                </tr>
              </table>
 
              <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td width="2%" class="tituloListas" colspan="6">
				  	<input name="datos" type="hidden" value="">
				  </td>
                </tr>
                <cfoutput> 
                <tr class="tituloListas"> 
                  <td ></td>
                  <td>#LB_Tipo#</td>
                  <td nowrap><strong>#LB_Documento#</strong></td>
                  <td><strong>#LB_Fecha#</strong></td>
                  <td nowrap><div align="right"><strong>#LB_Moneda#</strong></div></td>
                  <td nowrap><div align="right">#LB_Total#</div></td>
                </tr>
                </cfoutput>
					<cfoutput query="rsDocumentos" startrow="#StartRow_rsDocumentos#" maxrows="#MaxRows_rsDocumentos#"> 
					  <tr <cfif rsDocumentos.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>
					  	onMouseOver="javascript: style.color = 'red'" 
						onMouseOut="javascript: style.color = 'black'"
						 style="cursor: pointer;">  
						<td><input type='checkbox' name='chk' value="#rsDocumentos.IDpago#|#rsDocumentos.CCTcodigo#|#rsDocumentos.Ddocumento#" <cfif rsDocumentos.Balance EQ 0 or rsDocumentos.disponible LTE -0.01>disabled</cfif>></td>
						<td nowrap="nowrap"
							onClick="javascript:Editar('#rsDocumentos.IDpago#|#rsDocumentos.CCTcodigo#|#rsDocumentos.Ddocumento#');"
							><div align="left">#rsDocumentos.CCTcodigo#</div></td>
						<td nowrap
							onClick="javascript:Editar('#rsDocumentos.IDpago#|#rsDocumentos.CCTcodigo#|#rsDocumentos.Ddocumento#');"
							>#rsDocumentos.Ddocumento#</td>
						<td nowrap="nowrap"
							onClick="javascript:Editar('#rsDocumentos.IDpago#|#rsDocumentos.CCTcodigo#|#rsDocumentos.Ddocumento#');"
							><div align="left">#DateFormat(rsDocumentos.EFfecha, 'dd/mm/yyyy')#</div></td>
						<td nowrap
							onClick="javascript:Editar('#rsDocumentos.IDpago#|#rsDocumentos.CCTcodigo#|#rsDocumentos.Ddocumento#');"
							><div align="right">#rsDocumentos.Mnombre#</div></td>
						<td nowrap
							onClick="javascript:Editar('#rsDocumentos.IDpago#|#rsDocumentos.CCTcodigo#|#rsDocumentos.Ddocumento#');"
							><div align="right">#LSNumberformat(rsDocumentos.EFtotal,"L,0.00")#</div></td>
					  </tr>
					</cfoutput>
	               <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5"><table border="0" width="50%" align="center">
                      <cfoutput> 
                        <tr> 
                          <td width="23%" align="center"> <cfif PageNum_rsDocumentos GT 1>
                              <a href="#CurrentPage#?PageNum_rsDocumentos=1#navegacion#"><img src="/cfmx/sif/imagenes/First.gif" border=0></a> <!--- #QueryString_rsDocumentos# --->
                            </cfif> </td>
                          <td width="31%" align="center"> <cfif PageNum_rsDocumentos GT 1>
                              <a href="#CurrentPage#?PageNum_rsDocumentos=#Max(DecrementValue(PageNum_rsDocumentos),1)##navegacion#"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a> <!--- #QueryString_rsDocumentos# --->
                            </cfif> </td>
                          <td width="23%" align="center"> <cfif PageNum_rsDocumentos LT TotalPages_rsDocumentos>
                              <a href="#CurrentPage#?PageNum_rsDocumentos=#Min(IncrementValue(PageNum_rsDocumentos),TotalPages_rsDocumentos)##navegacion#"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a> <!--- #QueryString_rsDocumentos# --->
                            </cfif> </td>
                          <td width="23%" align="center"> <cfif PageNum_rsDocumentos LT TotalPages_rsDocumentos>
                              <a href="#CurrentPage#?PageNum_rsDocumentos=#TotalPages_rsDocumentos##navegacion#"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a> <!--- #QueryString_rsDocumentos# --->
                            </cfif> </td>
                        </tr>
                      </cfoutput> </table></td>
                </tr>
              </table>
              
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<cfoutput>              
					<tr>
						<td align="center">
							<input name="NuevoE" type="submit" value="#BTN_Nuevo#" onclick= "javascript:document.form1.action='AplicaDocsAfavorCC.cfm';">
							<cfif rsDocumentos.RecordCount>
								<input name="Aplicar" type="submit" value="#BTN_Aplicar#" onclick= "return valida();">
								<input name="Reporte" type="submit" id="Reporte" value="#LB_Reporte#" onClick="javascript: document.form1.method='get'; document.form1.action='../reportes/ReporteAplicaDoc.cfm'">
							</cfif>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					</cfoutput>                    
				</table>
				
				<cfoutput>
				<input name="pageNum_rsDocumentos" type="hidden" value="<cfif isdefined('form.pageNum_rsDocumentos')>#form.pageNum_rsDocumentos#<cfelse>1</cfif>" >
				</cfoutput> 
           </form>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfset MSG_validaChecks = t.Translate('MSG_validaChecks','¿Desea aplicar los documentos seleccionados?')>
<cfset MSG_validaChecksOld = t.Translate('validaChecksOld','Debe seleccionar al menos un documento para aplicar')>
<cfset MSG_NoExistenDoctos = t.Translate('MSG_NoExistenDoctos','¡No existen documentos por aplicar!')>
<cfset MSG_EscojerDocto = t.Translate('MSG_EscojerDocto','Debe escoger un documento de pago para aplicar')>
<cfset MSG_NoHayDoctos = t.Translate('MSG_NoHayDoctos','No hay documentos de pago para aplicar')>

<cfoutput>
<script language="JavaScript1.2">
	function valida() {
		if (validaChecks()) 
			return confirm('#MSG_validaChecks#');	
		return false;
	}

	function validaChecksOld() {
		document.form1.action='listaDocsAfavorCC.cfm';
		<cfif rsDocumentos.recordCount GT 0> 
			<cfif rsDocumentos.recordCount EQ 1>
				if (document.form1.chk.checked)					
					return true;
				else
					alert("#MSG_validaChecksOld#");									
			<cfelse>
				var bandera = false;
				var i;
				for (i = 0; i < document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) bandera = true;						
				}
				if (bandera)
					return true;
				else
					alert("#MSG_validaChecksOld#");									
			</cfif>	 			
		<cfelse>
			alert("#MSG_NoExistenDoctos#");							
		</cfif>
		return false;
	}
	
	function validaChecks(){
		f = document.form1;
		if (f.chk != null) {
			if (f.chk.value) {
				if (!f.chk.checked) { 
					alert("#MSG_EscojerDocto#");
					return false;
				} else {
					f.action='listaDocsAfavorCC.cfm';
					return true;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						f.action='listaDocsAfavorCC.cfm';
						return true;
					}
				}
				alert("#MSG_EscojerDocto#");
				return false;
			}
		} else {
			alert("#MSG_NoHayDoctos#");
			return false;
		}
	}

	function Marcar(f) {
		<cfif rsDocumentos.recordCount GT 0>
		//var f = document.form1;
		if (f.chk != null) {
			if (f.chk.value != null) {
				if (!f.chk.disabled)f.chk.checked = f.chkTodos.checked;
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (!f.chk[i].disabled) f.chk[i].checked = f.chkTodos.checked;
				}
			}
		}
		</cfif>
	}

	function Editar(data) {
		if (data!="") {
			document.form1.action='AplicaDocsAfavorCC.cfm';
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}

</script>
</cfoutput>

