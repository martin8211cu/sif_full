<cfif isdefined("url.CBTCid")>
	<cfset form.CBTCid = url.CBTCid>
</cfif>

<cfif isdefined("url.CBDUid")>
	<cfset form.CBDUid = url.CBDUid>
</cfif>

<cfif isdefined("URL.modoDet")>
	<cfset Form.modoDet=URL.modoDet>
</cfif>
<cfif isdefined("Form.CBDUid")>
	<cfset modoDet="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modoDet")>
		<cfset modoDet="ALTA">
	<cfelseif Form.modoDet EQ "CAMBIO">
		<cfset modoDet="CAMBIO">
	<cfelse>
		<cfset modoDet="ALTA">
	</cfif>
</cfif>

<style type="text/css">
<!--
.Estilo1 {
	color: #CC3300;
}
-->
</style>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<table width="100%" border="0">
		<tr>
			<td colspan="2"><strong>Tarjetas de Credito:</strong></td>
		</tr>
		<cfif modo NEQ 'ALTA'>
		<form name="form2" action="seguridadTCE_sql.cfm" method="post">
        	<tr>
                <td class="titulolistas">Tarjeta de Cr&eacute;dito&nbsp;</td>
                <td class="titulolistas">Conciliar&nbsp;</td>
                <td class="titulolistas">Consultar&nbsp;</td>
          	</tr>
			<tr>
				<td nowrap>
					<div id="CMPTarjCred"> 
                    	<cfset valuesArrayTCE = ArrayNew(1)>
                        <cfif modoDet eq "CAMBIO"  and isdefined("form.CBTCid") and len(trim(form.CBTCid))>
                            <cfquery datasource="#Session.DSN#" name="rsTCE">
                                select 
                                CBTCid as Id,
                                CBTCDescripcion
                                from CBTarjetaCredito			
                                where Ecodigo = #session.Ecodigo#
                                and CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTCid#">
                            </cfquery>
       						<cfset ArrayAppend(valuesArrayTCE, rsTCE.Id)>
                            <cfset ArrayAppend(valuesArrayTCE, rsTCE.CBTCDescripcion)>
                        </cfif> 
						<cf_conlis      
								campos = "Id,CBTCDescripcion"
                                valuesArray="#valuesArrayTCE#"
								desplegables = "N,S"
								modificables = "N,N"
								size = "0,55"
								title="Lista de Cuentas Bancarias"
								tabla="CBTarjetaCredito tj 
										inner join DatosEmpleado de
											on tj.DEid=de.DEid
											"																					 
								columnas="	tj.CBTCid as Id,tj.CBTCDescripcion,    
											de.DEnombre,de.DEapellido1,de.DEapellido2,
											tj.CBTCid"    
													   
								filtro="tj.Ecodigo=#session.Ecodigo#  
                                     and (
                                      select count(1)
                                        from CBDusuarioTCE b
                                      where b.CBTCid = tj.CBTCid
                                      and CBUid = #Form.us#
                                    ) = 0
                                "                                                           
								desplegar="CBTCDescripcion, DEnombre,DEapellido1,DEapellido2"
								etiquetas="Tarjeta Credito,Nombre, Apellido 1, Apellido 2"
								formatos="S,S,S,S,S"
								align="left,left,left,left"
								asignar="Id,CBTCDescripcion"
								showEmptyListMsg="true"
								EmptyListMsg="-- No existen tarjetas --"
								tabindex="2"
								top="100"
								left="200"
								width="850"
								height="600"
								asignarformatos="S,S,S"
								form="form2"> 
									  
					</div>                       
				</td>
                <cfif modoDet eq "CAMBIO"  and isdefined("form.CBDUid") and len(trim(form.CBDUid))>
                	<cfquery datasource="#session.dsn#" name="rsDetalle">
                    	select Conciliador, CBDUmovimientos
                        from CBDusuarioTCE
                        where CBDUid = #Form.CBDUid#
                    </cfquery>
                </cfif> 
                
                <td align="center"><input name="TCEConciliar" type="checkbox" <cfif modoDet eq "CAMBIO" and isdefined("rsDetalle.Conciliador") and rsDetalle.Conciliador eq 1>checked</cfif>>&nbsp;</td>
                <td align="center"><input name="TCEConsultar" type="checkbox" <cfif modoDet eq "CAMBIO" and isdefined("rsDetalle.CBDUmovimientos") and rsDetalle.CBDUmovimientos eq 1>checked</cfif>>&nbsp;</td>
				<cfoutput>
                <input type="hidden" name="Usucodigo" value="#Form.Usucodigo#" />
                <input type="hidden" name="user" value="#Form.us#" />
                <input type="hidden" name="addDet" value="" />
                </cfoutput>			
			</tr>
            <tr>
            	<td align="center" colspan="3">
                	<cfif modoDet neq "CAMBIO">
						<input type="button" name="agregarDet" value="Agregar" onclick="validar();"/>
                    <cfelse>
                    	<input type="hidden" name="CBDUid" value="<cfoutput>#Form.CBDUid#</cfoutput>" />
                    	<input type="submit" name="cambiarD" value="Cambiar"/>    
                    	<input type="submit" name="nuevoD" value="Nuevo" />    
                    </cfif>
                </td>
            </tr>
            <tr><td>&nbsp;</td></tr>
		</form>
        <form name="form3" method="post">
            <tr>
                <td colspan="4">		
                    <cf_dbfunction name="to_char" args="cbd.CBTCid" returnVariable="LvarTarjeta">
                    <cf_dbfunction name="to_char" args="cbd.CBUid" returnVariable="LvarUs">
                    <cf_dbfunction name="to_char" args="cbd.CBDUid" returnVariable="LvarUsID">
                    <cf_dbfunction name="to_char" args="cbd.Conciliador" returnVariable="LvarConc">
                    <cf_dbfunction name="to_char" args="cbd.CBDUmovimientos" returnVariable="LvarCons">
                    
            <cfset LvarImgChecked	= "'<img border=""0"" src=""/cfmx/sif/imagenes/borrar01_S.gif"" style=""cursor:pointer;"" onClick=""sbBaja('#LvarCNCT# #LvarTarjeta# #LvarCNCT#','#LvarCNCT# #LvarUs# #LvarCNCT#');"">'">
            <cfset LvarCheckConc        = "'<img src=""/cfmx/sif/imagenes/checked.gif"" onClick=""document.form3.nosubmit=true;this.src=''seguridadTCE_checkbox.cfm?CBDUid='#LvarCNCT# #LvarUsID# #LvarCNCT#'&CBUid='#LvarCNCT# #LvarUs# #LvarCNCT#'&Who=Conciliador&Var='#LvarCNCT# #LvarConc# #LvarCNCT#'''"">'">
            <cfset LvarUnCheckConc      = "'<img src=""/cfmx/sif/imagenes/unchecked.gif"" onClick=""document.form3.nosubmit=true;this.src=''seguridadTCE_checkbox.cfm?CBDUid='#LvarCNCT# #LvarUsID# #LvarCNCT#'&CBUid='#LvarCNCT# #LvarUs# #LvarCNCT#'&Who=Conciliador&Var='#LvarCNCT# #LvarConc# #LvarCNCT#'''"">'">
            <cfset LvarCheckCons        = "'<img src=""/cfmx/sif/imagenes/checked.gif"" onClick=""document.form3.nosubmit=true;this.src=''seguridadTCE_checkbox.cfm?CBDUid='#LvarCNCT# #LvarUsID# #LvarCNCT#'&CBUid='#LvarCNCT# #LvarUs# #LvarCNCT#'&Who=CBDUmovimientos&Var='#LvarCNCT# #LvarConc# #LvarCNCT#'''"">'">
            <cfset LvarUnCheckCons      = "'<img src=""/cfmx/sif/imagenes/unchecked.gif"" onClick=""document.form3.nosubmit=true;this.src=''seguridadTCE_checkbox.cfm?CBDUid='#LvarCNCT# #LvarUsID# #LvarCNCT#'&CBUid='#LvarCNCT# #LvarUs# #LvarCNCT#'&Who=CBDUmovimientos&Var='#LvarCNCT# #LvarCons# #LvarCNCT#'''"">'">
            
            <cfinvoke component="sif.Componentes.pListas" method="pLista"
        
                    tabla=	"	CBDusuarioTCE cbd
                                    inner join CBUsuariosTCE cbu
                                        on  cbu.CBUid = cbd.CBUid
                                    inner join CBTarjetaCredito cbt
                                        on cbd.CBTCid = cbt.CBTCid
                            "
                                    
                    columnas="	cbd.CBDUid,
                    			cbd.CBTCid,
                                cbd.CBUid,
                                cbd.Conciliador,
                                cbd.CBDUmovimientos,
                                case cbd.Conciliador when 1 then #preserveSingleQuotes(LvarCheckConc)# else #preserveSingleQuotes(LvarUnCheckConc)#  end as Conciliar,
								case cbd.CBDUmovimientos when 1 then #preserveSingleQuotes(LvarCheckCons)# else #preserveSingleQuotes(LvarUnCheckCons)#  end as Consultar,
                                cbt.CBTCDescripcion,
                                cbu.Usucodigo,
                                #preserveSingleQuotes(LvarImgChecked)# as borrar,
                                #Form.us# as us"
                
                    filtro="cbd.CBUid = #Form.us#"
                            
                    desplegar="CBTCDescripcion, Conciliar, Consultar, borrar"
                    etiquetas="Tarjeta de Credito, Conciliar, Consultar Movimientos, "
                    formatos="S,U,U,U"
                    align="left,center,center,left"
                    ajustar="S,S,S,N"
                    QueryString_lista="modo=#modo#&us=#form.us#&Usucodigo=#form.Usucodigo#"
                    formname="form3"
                    ira="seguridadTCE_sql.cfm"
                    form_method="post"
                    keys="CBTCid,Usucodigo"
                    showLink="yes"
                    incluyeForm="false"
                    filtrar_automatico="yes"
                    MaxRows="5"
                    PageIndex ="2">
                </cfinvoke>
                </td>
            </tr>    
            <input type="hidden" name="btnBajaDet" value="" />
        </form>
		<cfelse>
			<tr>
				<td colspan="2">
					<table width="100%" border="0">
						<tr>
							<td><div align="center"><span class="Estilo1"><cfoutput>Se debe selecccionar un usuario</cfoutput></span></div></td>
						</tr>
					</table>
				</td>		
			</tr>
		</cfif>
	</table>

<script language="javascript">
	
	function sbBaja(Tarjeta,usuario)
	{
		if (confirm("¿Desea borrar la tarjeta?"))
		{
			document.form3.btnBajaDet.value = "Delete";
			document.form3.CBTCid.value = Tarjeta;
			document.form3.CBUid.value = usuario;
			document.form3.Usucodigo.value = <cfoutput>#Form.Usucodigo#</cfoutput>;	
			document.form3.submit();
		}
		return false;
	}
	
	function validar(){
		if(document.form2.CBTCDescripcion.value==""){
			alert("Debe seleccionar una tarjeta");
			return false;
		}else{
			document.form2.addDet.value = 1;
			document.form2.submit();
		return true;}
	}
</script>
