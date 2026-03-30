<cfparam name="LvarPagina" default="/sif/fa/operacion/Ingresos.cfm">
<cfparam name="LvarPaginaIni" default="/sif/fa/operacion/listaTransaccionesFA.cfm">
<cfparam name="LvarSQLPagina" default="/sif/fa/operacion/SQLTransaccionesFA.cfm">
<cfparam name="LvarEditPagina" default="/sif/fa/operacion/TransaccionesFA.cfm">
<cfparam name="LvarPagosPagina" default="/sif/fa/operacion/PagosFA.cfm">
<cfparam name="LvarPagosSQLPagina" default="/sif/fa/operacion/SQLPagosFA.cfm">
<cfparam name="moduloOrigen" default="">

<cf_templateheader title="Registro de Transacciones">
	<div class="row">
	<!---<table width="100%" cellpadding="2" cellspacing="0" border="0">
  		<tr>
           <td height="38" align="right"> --->
                <cfif isdefined('session.Caja') and len(trim(#session.Caja#)) gt 0>
                     <cfquery name="rsCaja" datasource="#session.dsn#">
                      select FCcodigo, FCdesc
                       from FCajas where FCid = #session.Caja#
                       and Ecodigo = #session.Ecodigo#
                     </cfquery>
                </cfif>
                <!--- <cfoutput><strong>Caja activa:</strong> #rsCaja.FCcodigo# - #rsCaja.FCdesc#</cfoutput>  --->
          <!---</td>
        </tr>
    	<tr>
            <td valign="top">--->
               	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Registro de Transacciones">

               	<div class="col-sm-12 col-md-10">
					<!--- Portlet de Navegación de FA --->

					<!--- Posteo --->
					<cfif isDefined("Form.Aplicar") and isDefined("Form.chk")>
						<cfset chequeados = ListToArray(Form.chk)>
						<cfset cuantos = ArrayLen(chequeados)>

						<cfloop index="CountVar" from="1" to="#cuantos#">
							<cfset valores = ListToArray(chequeados[CountVar],"|")>
							<!--- ejecuta el proc.--->
							<!---<cftry>--->
			                 <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="CreaIntarc" CrearPresupuesto="false" returnvariable="INTARC"/>
			                 <cfinvoke component= "sif.Componentes.PRES_Presupuesto"	 method	= "CreaTablaIntPresupuesto"  Conexion = "#session.dsn#" returnvariable="IntPresup"/>
			                 <cfinvoke component="IETU" method="IETU_CreaTablas" conexion="#session.dsn#" />
			                 <cfinvoke component="sif.fa.operacion.CostosAuto" Conexion="#session.dsn#" method="CreaCostos" returnvariable="Tb_Calculo"/>

			                  <cf_dbtemp name="DIFERENCIAL" returnvariable="DIFERENCIAL" datasource="#session.dsn#">
			                    <cf_dbtempcol name="INTLIN"    type="numeric"      identity="yes">
			                    <cf_dbtempcol name="INTORI"    type="char(4)"      mandatory="yes">
			                    <cf_dbtempcol name="INTREL"    type="int" 		   mandatory="yes">
			                    <cf_dbtempcol name="INTDOC"    type="char(20)"     mandatory="yes">
			                    <cf_dbtempcol name="INTREF"    type="varchar(25)"  mandatory="yes">

			                    <cf_dbtempcol name="INTMON"    type="money"        mandatory="yes">
			                    <cf_dbtempcol name="INTTIP"    type="char(1)"      mandatory="yes">

			                    <cf_dbtempcol name="INTDES"    type="varchar(80)"  mandatory="yes">

			                    <cf_dbtempcol name="INTFEC"    type="varchar(8)"   mandatory="yes">
			                    <cf_dbtempcol name="INTCAM"    type="float"        mandatory="yes">
			                    <cf_dbtempcol name="Periodo"   type="int"          mandatory="yes">
			                    <cf_dbtempcol name="Mes"       type="int"          mandatory="yes">
			                    <cf_dbtempcol name="Ccuenta"   type="numeric"      mandatory="yes">

			                    <cf_dbtempcol name="CFcuenta"  type="numeric"      mandatory="no">
			                    <cf_dbtempcol name="Mcodigo"   type="numeric"      mandatory="yes">
			                    <cf_dbtempcol name="Ocodigo"   type="int"          mandatory="yes">
			                    <cf_dbtempcol name="INTMOE"    type="money"        mandatory="yes">
			                    <cf_dbtempcol name="TIPO"      type="char(2)"      mandatory="yes">

			                    <cf_dbtempkey cols="INTLIN">
			                </cf_dbtemp>

			                 <cftransaction>
			                    <cfinvoke component="sif.Componentes.FA_posteotransacciones" method="posteo_documentosFA" returnvariable="any">
			                            <cfinvokeargument name="FCid" 		value="#valores[1]#">
			                            <cfinvokeargument name="ETnumero" 	value="#valores[2]#">
			                            <cfinvokeargument name="Ecodigo" 	value="#Session.Ecodigo#">
			                            <cfinvokeargument name="usuario"    value="#Session.usucodigo#">
										<cfinvokeargument name="debug"    	value="N">
			                            <cfinvokeargument name="INTARC"    	value="#INTARC#">
			                            <cfinvokeargument name="IntPresup"  value="#IntPresup#">
			                            <cfinvokeargument name="Tb_Calculo"  value="#Tb_Calculo#">
			                            <cfinvokeargument name="DIFERENCIAL"  value="#DIFERENCIAL#">


								</cfinvoke>
			               </cftransaction>

						</cfloop>

						<cflocation addtoken="no" url="#LvarPaginaIni#">
					</cfif>


						<!--- Estilos para las listas --->
			            <cfif isDefined("url.ETnumero") and isDefined("url.FCid") and isDefined("url.Cambio") >
			             <cfset Form.ETnumero =  url.ETnumero>
						 <cfset Form.FCid = url.FCid>
			             <cfset Form.Cambio = url.Cambio>
			             <cfset Form.modoDet = url.modoDet>
			            </cfif>


						<cfif isdefined("Form.Cambio") and len(trim(form.Cambio))>
							<cfset modo="CAMBIO">
						<cfelse>
							<cfif not isdefined("Form.modo")>
								<cfset modo="ALTA">
							<cfelseif Form.modo EQ "CAMBIO">
								<cfset modo="CAMBIO">
							<cfelse>
								<cfset modo="ALTA">
							</cfif>
						</cfif>

						<cfif not isdefined("Form.modoDet")>
							<cfset modoDet = "ALTA">
						</cfif>

						<cfif isDefined("Form.NuevoE")>
							<cfset modo = "ALTA">
							<cfset modoDet = "ALTA">
						</cfif>

			            <cfif isDefined("url.NuevoE")>
							<cfset Form.NuevoE = url.NuevoE>
							<cfset modo = "ALTA">
							<cfset modoDet = "ALTA">
						</cfif>

						<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0>
							<cfset modo = "CAMBIO">
							<cfset modoDet = "ALTA">
						</cfif>

						<cfif isdefined("Form.NuevoL")>
							<cfset modo = "ALTA">
						</cfif>

						<cfset FCid = "">
						<cfset ETnumero = "">
						<cfset DTlinea = "">


						<cfif not isDefined("Form.NuevoE") and not isDefined("Form.NuevoL") and not isDefined("url.Cambio")>
							<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
								<cfset arreglo = ListToArray(Form.datos,"|")>
								<cfset FCid = Trim(arreglo[1])>
								<cfset ETnumero = Trim(arreglo[2])>
							<cfelse>
								<cfif not isDefined("Form.ETnumero") and not isDefined("Form.FCid")>
									<cflocation addtoken="no" url="listaTransaccionesFA.cfm">
								<cfelse>
									<cfif Len(Trim(Form.ETnumero)) NEQ 0 and Len(Trim(Form.FCid)) NEQ 0>
										<cfset FCid = Form.FCid>
										<cfset ETnumero = Form.ETnumero>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
			            <!---<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			              <tr>
			                 <td> <cfinclude template="formTransaccionesFA.cfm"></td>
			              </tr>
			            </table> --->

			            <cfinclude template="formTransaccionesFA.cfm">

						<script language="JavaScript1.2">

							var popUpWinAlertas=null;
							function popUpWindowAlertas(URLStr, left, top, width, height)
							{
							  if(popUpWinAlertas)
							  {
								if(!popUpWinAlertas.closed) popUpWinAlertas.close();
							  }
							  popUpWinAlertas = open(URLStr, 'popUpWinAlertas', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
							  if (! popUpWinAlertas && !document.popupblockerwarning) {
								alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
								document.popupblockerwarning = 1;
							  }
							}

							function doConlisVariables(Cid,DTlinea,desc){
							<cfoutput>
								if ((Cid)&&(Cid>0)) {

									popUpWindowAlertas('datosVariables-Popup.cfm?Cid='+Cid+'&DTlinea='+DTlinea+'&desc='+desc,150,150,600,400);
								}
								document.form2.nosubmit=true;
								return false;
							</cfoutput>
							}
						</script>

            	</div>
		        <cf_web_portlet_end>
			<!---</td>
		</tr>
	</table>	 --->
</div>
<cf_templatefooter>
