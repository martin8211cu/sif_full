<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeTipoDeBeca" Default="Lista De Tipo De Beca" XmlFile="/rh/generales.xml" returnvariable="LB_ListaDeTipoDeBeca"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeEmpleados" Default="Lista De Empleados" XmlFile="/rh/generales.xml" returnvariable="LB_ListaDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Simbolo" Default="Simbolo" XmlFile="/rh/generales.xml" returnvariable="LB_Simbolo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeMonedas" Default="Lista De Monedas" XmlFile="/rh/generales.xml" returnvariable="LB_ListaDeMonedas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Esta_seguro_de_que_desea_aplicar_este_formulario" Default="¿Está seguro de que desea aplicar este formulario?"	 returnvariable="MSG_Esta_seguro_de_que_desea_aplicar_este_formulario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Esta_seguro_de_que_desea_eliminar_este_formulario" Default="¿Está seguro de que desea eliminar este formulario?"	 returnvariable="MSG_Esta_seguro_de_que_desea_eliminar_este_formulario"/>

<cfset btnExclude = "">
<cfset readonly = "false">
<cfif isdefined('form.RHEBEid') and len(trim(form.RHEBEid)) gt 0>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetEBE" returnvariable="rsEBeca">
        <cfinvokeargument name="RHEBEid" 		value="#form.RHEBEid#">
    </cfinvoke>
	<cfset modo = "CAMBIO">
    <cfset btnExclude = "Cambio">
    <cfset readonly = "true">
</cfif>

<cfoutput>
<script language="javascript1.2" type="text/javascript">

	function fnVisivilidadDiv(name,RHECBid){
		cdiv = document.getElementById("ContenedorDiv_"+RHECBid);
		divs = cdiv.getElementsByTagName('div');
		for(i=0;i<divs.length;i++){
			if(divs[i].id == "div_"+name){
				divs[i].style.display="";
			}
			else
				divs[i].style.display="none";
		}
	}
	
	function fnHabilitarInput(v, name, tipo) {
		obj = eval("document.form2.RHDCBtipoValor_" + name);
		if(tipo == 2){
			objM = eval("document.form2.Miso4217" + name);
			objI = document.getElementById("img_form2_Mcodigo" + name);
		}else if(tipo == 4)
			objI = document.getElementById("img_form2_RHDCBtipoValor_" + name);
		if(v){
			if(obj){
				obj.disabled=false;
				obj.focus();
			}
			if((tipo == 2) && objM){
				objM.disabled=false;
			}
			if((tipo == 2 || tipo == 4) && objI)
				objI.style.display="";
		}else{
			if(obj)
				obj.disabled=true;
			if((tipo == 2) && objM)
				objM.disabled=true;
			if((tipo == 2 || tipo == 4) && objI)
				objI.style.display="none";
		}
	}
	function funcAplicarEB(){
		return (confirm('#MSG_Esta_seguro_de_que_desea_aplicar_este_formulario#'));
	}
	function funcEliminarEB(){
		return (confirm('#MSG_Esta_seguro_de_que_desea_eliminar_este_formulario#'));
	}
	
	function funcRegresar(){
		location.href = "/cfmx/rh/autogestion/operacion/RegBecas.cfm";
		return false;
	}
</script>
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
    	<cfif modo eq "ALTA">
    	<form name="form1" method="post" action="RegBecas-sql.cfm">
		<tr>
			<td align="right">#LB_Beca#:</td>
            <td>
            	<cfset valuesArray = ArrayNew(1)>
				<cfif modo NEQ 'ALTA'>
                    <cfquery name="rsTBeca" datasource="#session.DSN#">
                        select RHTBid,RHTBcodigo,RHTBdescripcion
                        from RHTipoBeca
                        where RHTBid = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEBeca.RHTBid#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArray, rsTBeca.RHTBid)>
                  <cfset ArrayAppend(valuesArray, rsTBeca.RHTBcodigo)>
                  <cfset ArrayAppend(valuesArray, rsTBeca.RHTBdescripcion)>
                </cfif>
            	<cf_conlis
                    campos="RHTBid,RHTBcodigo,RHTBdescripcion"
                    desplegables="N,S,S"
                    modificables="N,S,N"
                    size="0,10,50"
                    title="#LB_ListaDeTipoDeBeca#"
                    tabla="RHTipoBeca"
                    columnas="RHTBid, RHTBcodigo, RHTBdescripcion"
                    filtro="RHTBesCorporativo = 1 or (RHTBesCorporativo = 0 and  Ecodigo = #session.Ecodigo#)"
                    desplegar="RHTBcodigo, RHTBdescripcion"
                    filtrar_por="RHTBcodigo|RHTBdescripcion"
                    filtrar_por_delimiters="|"
                    etiquetas="#LB_Codigo#,#LB_Descripcion#"
                    formatos="S,S"
                    align="left,left"
                    asignar="RHTBid,RHTBcodigo,RHTBdescripcion"
                    asignarformatos="I,S,S"
                    showEmptyListMsg="true"
                    form = "form1"
                    valuesArray="#valuesArray#"
                    readonly="#readonly#"
                    tabindex = "1"
                >
            </td>
        </tr>
        <tr>
        	<td align="right" nowrap>#LB_Fecha#:</td>
            <cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
			<cfif modo NEQ 'ALTA'>
                <cfset fecha = LSDateFormat(rsEBeca.RHEBEfecha,'DD/MM/YYYY')>
            </cfif>
            <td>
            	<cf_sifcalendario name="RHEBEfecha" value="#fecha#" readonly="#readonly#">
            </td>
        </tr>
        <tr>
        	<td colspan="2">
            	<cf_botones modo="#modo#" sufijo="EB" exclude="#btnExclude#">
                <cfset ts = "">	
                <cfif modo neq "ALTA">
                    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
                        <cfinvokeargument name="arTimeStamp" value="#rsEBeca.ts_rversion#"/>
                    </cfinvoke>
                    <input type="hidden" name="RHEBEid" id="RHEBEid" value="#form.RHEBEid#">
                </cfif>
                <input type="hidden" name="ts_rversion" value="#ts#">
                <input type="hidden" name="DEid" value="#rsReferencia.llave#">
			</td>
        </tr>
        </form>
        </cfif>
		<cfif modo neq "ALTA">
        	<cfquery datasource="#Session.DSN#" name="rsEmpleado">
                select a.DEid,
                       a.Ecodigo,
                       a.Bid,
                       a.NTIcodigo, 
                       a.DEidentificacion, 
                       a.DEnombre, 
                       a.DEapellido1, 
                       a.DEapellido2, 
                       b.NTIdescripcion

                
                from DatosEmpleado a
                    inner join NTipoIdentificacion b
                        on a.NTIcodigo = b.NTIcodigo

                
                where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEBeca.DEid#">
            </cfquery>
            <cfquery name="rsBeca" datasource="#Session.DSN#">
                select RHTBcodigo,RHTBdescripcion
                from RHTipoBeca
                where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEBeca.RHTBid#">
            </cfquery>
        	<form name="form2" method="post" enctype="multipart/form-data"  action="RegBecas-sql.cfm">
   	  		<tr>
				<td colspan="2" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
					<cf_botones formName="form2" values="Guardar,Aplicar,Eliminar,Regresar" names="Guardar,AplicarEB,EliminarEB,Regresar" modo="#modo#" align="right">
				</td>
			</tr>
            <tr class="#Session.preferences.Skin#_thcenter">
               <td colspan="2" align="center">#rsBeca.RHTBcodigo# - #rsBeca.RHTBdescripcion#</td>
            <tr>
            <tr>
            	<td colspan="2" align="center">
                	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr>
                            <td width="5%" nowrap><strong>Plan de Estudios:&nbsp;</strong></td>
                            <td width="5%" nowrap>
                            	<input type="file" name="RHEBErutaPlan" value="" size="50">
                            </td>
                            <td><cf_botones formName="form3" values="Subir" names="Subir" modo="#modo#" align="left"></td>
                        </tr>
                        <cfif len(trim(rsEBeca.RHEBEarchivo))>
                        <tr><td colspan="3">
                        	<table id="tbArchivo" align="left" border="0" cellspacing="0" cellpadding="0">
                            	<tr>
                                    <td colspan="2"><strong>Archivo:&nbsp;</strong>#rsEBeca.RHEBEarchivo#</td>
                                    <td>&nbsp;</td>
                                    <td><a href="javascript: fnDescargar('#form.RHEBEid#');"><img src='/cfmx/rh/imagenes/Cfinclude.gif' border='0'></a></td>
                                    <td>&nbsp;</td>
                                    <td><a href="javascript: fnEliminar('#form.RHEBEid#');"><img src='/cfmx/rh/imagenes/delete.small.png' border='0'></a></td>
                       			</tr>
                            </table>
                        </td></tr>
                        
                        <script language="javascript1.2" type="text/javascript">
                        	
							function funcSubir(){
								errores = "";
									Lruta = trim(document.form2.RHEBErutaPlan.value).length;
									if(Lruta == 0)
									errores = errores + " -El campo Plan de Estudios es requerido.\n";
								if(errores.length > 0){
									alert("Se presentaron los siguientes errores:\n" + errores);
									return false;
								}
								return true;
							}
							
							function fnDescargar(RHEBEid){
                                params = "?Tipo=1&RHEBEid="+RHEBEid;
                                var frame = document.getElementById("FRAMECJNEGRA");
                                frame.src = "archivoBecas.cfm"+params;		
                                
                            }
							
							function fnEliminar(RHEBEid){
								if(confirm("Está seguro de eliminar el archivo")){
									params = "?Tipo=2&RHEBEid="+RHEBEid;
									var frame = document.getElementById("FRAMECJNEGRA");
									frame.src = "archivoBecas.cfm"+params;
								}
								
								document.getElementById('tbArchivo').innerHTML = "";
                                
                            }
							
						</script>
                        </cfif>
                    </table>
                     <iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
                </td>
            </tr>
        	<tr>
                <td colspan="2">
                    <cfinclude template="/rh/expediente/consultas/frame-infoEmpleado.cfm">
                </td>
			</tr>
        	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetDBE" returnvariable="rsDBeca">
                <cfinvokeargument name="RHEBEid" 		value="#form.RHEBEid#">
            </cfinvoke>
            <cfquery name="rsSelectCE" datasource="#session.dsn#">
                select ecb.RHECBid, RHECBdescripcion, RHECBesMultiple
                from RHTipoBecaConceptos tbc
                    inner join RHEConceptosBeca ecb
                        on ecb.RHECBid = tbc.RHECBid
                where tbc.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEBeca.RHTBid#">
            </cfquery>
            <tr class="#Session.preferences.Skin#_thcenter">
               <td colspan="2">Conceptos</td>
            <tr>
            <cfset NombreConceptos = "">
            <cfset camposRequeridos = "">
            <cfloop query="rsSelectCE">
                <tr><td align="right" valign="top">#rsSelectCE.RHECBdescripcion#&nbsp;&nbsp;</td>
                    <cfquery name="rsSelectCD" datasource="#session.dsn#">
                        select RHDCBid, RHDCBdescripcion, RHDCBtipo, RHDCBnegativos
                        from RHDConceptosBeca
                        where RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCE.RHECBid#">
                        order by RHDCBdescripcion
                    </cfquery>
                    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    	<cfif rsSelectCE.RHECBesMultiple eq 1>
                            <cfloop query="rsSelectCD">
                            	<cfquery name="rsExiste" dbtype="query">
                                    select RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor
                                    from rsDBeca
                                    where RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCD.RHDCBid#">
                                    and RHTBDFid is null
                                </cfquery>
                                <cfset checked = "">
                  <cfif rsExiste.recordcount gt 0>
                                	<cfset checked = "checked">
                                </cfif>
                            	<cfset NombreConceptos = NombreConceptos & "RHDCBid_#rsSelectCD.RHDCBid#" & ",">
                                <tr>
                                    <td width="3%">
                                    	<input type="checkbox" name="RHDCBid_#rsSelectCD.RHDCBid#" id="RHDCBid_#rsSelectCD.RHDCBid#" onclick="fnHabilitarInput(this.checked,'RHDCBid_#rsSelectCD.RHDCBid#',#rsSelectCD.RHDCBtipo#);" #checked#>
                                   		<input type="hidden" name="RHDCBtipo_RHDCBid_#rsSelectCD.RHDCBid#" id="RHDCBtipo_RHDCBid_#rsSelectCD.RHDCBid#" value="#rsSelectCD.RHDCBtipo#">
                                        <input type="hidden" name="RHECBesMultiple_RHDCBid_#rsSelectCD.RHDCBid#" id="RHECBesMultiple_RHDCBid_#rsSelectCD.RHDCBid#" value="#rsSelectCE.RHECBesMultiple#">
                                    	<input type="hidden" name="RHDCBid_RHDCBid_#rsSelectCD.RHDCBid#" id="RHDCBid_RHDCBid_#rsSelectCD.RHDCBid#" value="#rsSelectCD.RHDCBid#">
                                    </td>
                                    <td>#rsSelectCD.RHDCBdescripcion#</td>
                                    <td><cfset fnDibujarTipo("RHDCBid_#rsSelectCD.RHDCBid#", -1, rsSelectCD.RHDCBtipo, -1, rsSelectCD.RHDCBnegativos, rsExiste.RHDBEvalor,-1)></td>
                                  <script language="javascript1.2" type="text/javascript">fnHabilitarInput(document.form2.RHDCBid_#rsSelectCD.RHDCBid#.checked,'RHDCBid_#rsSelectCD.RHDCBid#',#rsSelectCD.RHDCBtipo#);</script>
                                </tr>
                         	</cfloop>
                       	 <cfelse>
                            <tr>
                                <td valign="top" width="5%" nowrap>
                                	<cfset NombreConceptos = NombreConceptos & "RHECBid_#rsSelectCE.RHECBid#" & ",">
                                	<select name="RHECBid_#rsSelectCE.RHECBid#" id="RHECBid_#rsSelectCE.RHECBid#" onchange="fnVisivilidadDiv(this.value,'#rsSelectCE.RHECBid#')">
                                        <cfloop query="rsSelectCD">
                                        	<cfquery name="rsExiste" dbtype="query">
                                                select RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor
                                                from rsDBeca
                                                where RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCD.RHDCBid#">
                                                and RHTBDFid is null
                                            </cfquery>
                                            <cfset selected = "">
                                            <cfif rsExiste.recordcount gt 0>
                                                <cfset selected = "selected">
                                            </cfif>
                                            <option value="#rsSelectCD.RHDCBid#" #selected#>#rsSelectCD.RHDCBdescripcion#</option>
                                        </cfloop>
                                    </select>
                                    <input type="hidden" name="RHECBesMultiple_RHECBid_#rsSelectCE.RHECBid#" id="RHECBesMultiple_RHECBid_#rsSelectCE.RHECBid#" value="#rsSelectCE.RHECBesMultiple#">
                                </td>
                                <td>&nbsp;</td>
                                <td valign="top" id="ContenedorDiv">
                                    <cfloop query="rsSelectCD">
                                    	<cfquery name="rsExiste" dbtype="query">
                                            select RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor
                                            from rsDBeca
                                            where RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCD.RHDCBid#">
                                            and RHTBDFid is null
                                        </cfquery>
                                        <div id="div_#rsSelectCD.RHDCBid#" style="display:none">
											<cfset fnDibujarTipo("RHDCBid_#rsSelectCD.RHDCBid#", -1, rsSelectCD.RHDCBtipo, -1, rsSelectCD.RHDCBnegativos, rsExiste.RHDBEvalor,-1)>
                                            <input type="hidden" name="RHDCBtipo_RHECBid_#rsSelectCE.RHECBid#_#rsSelectCD.RHDCBid#" id="RHDCBtipo_RHECBid_#rsSelectCE.RHECBid#_#rsSelectCD.RHDCBid#" value="#rsSelectCD.RHDCBtipo#">
                                            <input type="hidden" name="Valor_RHECBid_#rsSelectCE.RHECBid#_#rsSelectCD.RHDCBid#" id="Valor_RHECBid_#rsSelectCE.RHECBid#_#rsSelectCD.RHDCBid#" value="RHDCBid_#rsSelectCD.RHDCBid#">
                                        </div>
                                    </cfloop>
                                  <script language="javascript1.2" type="text/javascript">fnVisivilidadDiv(document.form2.RHECBid_#rsSelectCE.RHECBid#.value,'#rsSelectCE.RHECBid#');</script>
                                </td>
                           </tr>
                        </cfif>
                    </table></td>
                </tr>
            </cfloop>
            <cfquery name="rsSelectEBF" datasource="#session.dsn#">
                select RHTBEFid,RHTBEFcodigo,RHTBEFdescripcion
                from RHTipoBecaEFormatos
                where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEBeca.RHTBid#">
            </cfquery>
            <cfset NombreDetalles = "">
            <cfloop query="rsSelectEBF">
                <tr class="#Session.preferences.Skin#_thcenter">
                    <td colspan="2">#rsSelectEBF.RHTBEFdescripcion#</td>
                <tr>
                <cfquery name="rsSelectDBF" datasource="#session.dsn#">
                    select RHTBDFid, RHTBEFid, RHTBDForden, RHTBDFetiqueta, RHTBDFfuente, RHTBDFnegrita, RHTBDFitalica, RHTBDFsubrayado, RHTBDFtamFuente, RHTBDFcolor,
                            RHTBDFcapturaA, BMUsucodigo, ts_rversion, RHECBid, RHTBDFnegativos, RHTBDFcapturaB, RHTBDFrequerido
                    from RHTipoBecaDFormatos
                    where RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectEBF.RHTBEFid#">
                    order by RHTBDForden
                </cfquery>
                <cfloop query="rsSelectDBF">
                	<cfquery name="rsExiste" dbtype="query">
                        select RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor
                        from rsDBeca
                        where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectDBF.RHTBDFid#">
                    </cfquery>
                    <cfset style = "style='font:#rsSelectDBF.RHTBDFfuente#;font-size:#rsSelectDBF.RHTBDFtamFuente#px;color:###trim(rsSelectDBF.RHTBDFcolor)#">
      <cfif rsSelectDBF.RHTBDFnegrita eq 1>
                        <cfset style = style & ";font-weight:bold">
                    </cfif>
      <cfif rsSelectDBF.RHTBDFitalica eq 1>
                        <cfset style = style & ";font-style:italic">
                    </cfif>
      <cfif rsSelectDBF.RHTBDFsubrayado eq 1>
                        <cfset style = style & ";text-decoration:underline">
                    </cfif>
                    <cfset style = style & "'">
                    
                    <tr>
                        <td colspan="2">
                            <font style="#style#">#rsSelectDBF.RHTBDFetiqueta#:</font>
                        </td>
                    <tr>
                    
                    <tr>
                    	<td colspan="2">
                        	<cfset NombreDetalles = NombreDetalles & "RHTBDFid_#rsSelectDBF.RHTBDFid#,">
                            <cfif rsSelectDBF.RHTBDFrequerido eq 1>
                           		<cfset camposRequeridos = camposRequeridos & "RHDCBtipoValor_RHTBDFid_#rsSelectDBF.RHTBDFid#|#Mid(rsSelectDBF.RHTBDFetiqueta,1,50)#¬">
                            </cfif>
                            <cfif rsSelectDBF.RHTBDFcapturaA eq 2>
                           		<cfset camposRequeridos = camposRequeridos & "McodigoRHTBDFid_#rsSelectDBF.RHTBDFid#|#Mid(rsSelectDBF.RHTBDFetiqueta,1,50)#¬">
                            </cfif>
                            <cfif len(trim(rsSelectDBF.RHTBDFcapturaB)) gt 0>
                           		<cfset camposRequeridos = camposRequeridos & "RHDCBtipoValor_B_RHTBDFid_#rsSelectDBF.RHTBDFid#|#Mid(rsSelectDBF.RHTBDFetiqueta,1,50)#,">
                            </cfif>
                            <cfif rsSelectDBF.RHTBDFcapturaB eq 2>
                           		<cfset camposRequeridos = camposRequeridos & "McodigoB_RHTBDFid_#rsSelectDBF.RHTBDFid#|#Mid(rsSelectDBF.RHTBDFetiqueta,1,50)#¬">
                            </cfif>
                        	<cfset fnDibujarTipo("RHTBDFid_#rsSelectDBF.RHTBDFid#", iif(len(trim(rsSelectDBF.RHECBid)) eq 0, -1, rsSelectDBF.RHECBid), rsSelectDBF.RHTBDFcapturaA, iif(len(trim(rsSelectDBF.RHTBDFcapturaB)) eq 0, -1, rsSelectDBF.RHTBDFcapturaB), rsSelectDBF.RHTBDFnegativos, rsExiste.RHDBEvalor, iif(len(trim(rsExiste.RHDCBid)) eq 0, -1, rsExiste.RHDCBid))>
                        	<input type="hidden" name="RHTBDFid_#rsSelectDBF.RHTBDFid#" id="RHTBDFid_#rsSelectDBF.RHTBDFid#" value="#rsSelectDBF.RHTBDFid#">
                            <input type="hidden" name="Detalle_#rsSelectDBF.RHTBDFid#" id="Detalle_#rsSelectDBF.RHTBDFid#" value="#rsSelectDBF.RHTBDFid#">
                       		<input type="hidden" name="RHTBDFcapturaA_#rsSelectDBF.RHTBDFid#" id="RHTBDFcapturaA_#rsSelectDBF.RHTBDFid#" value="#rsSelectDBF.RHTBDFcapturaA#">
                            <input type="hidden" name="RHTBDFcapturaB_#rsSelectDBF.RHTBDFid#" id="RHTBDFcapturaB_#rsSelectDBF.RHTBDFid#" value="#rsSelectDBF.RHTBDFcapturaB#">
                       </td>
                    </tr>
                </cfloop>
            </cfloop>
             	<input type="hidden" name="RHEBEid" id="RHEBEid" value="#form.RHEBEid#">
                <input name="NombreConceptos" type="hidden" value="#NombreConceptos#" />
                <input name="NombreDetalles" type="hidden" value="#NombreDetalles#" />
            </form>
      </cfif>
	</table>
	<script language="javascript1.2" type="text/javascript">
			
		function trim(cad){  
			return cad.replace(/^\s+|\s+$/g,"");  
		}
		
		function funcGuardar(){
			return funcValidar();
		}
		
		function funcAplicarEB(){
			return funcValidar();
		}
		<cfif modo neq "ALTA">
		function funcValidar(){
			errores = "";
			<cfloop list="#camposRequeridos#" index="nombre" delimiters="¬">
				L#ListGetAt(nombre,1,'|')# = trim(document.form2.RHDCBtipoValor_#ListGetAt(nombre,1,'|')#.value).length;
				if(L#ListGetAt(nombre,1,'|')# == 0)
				errores = errores + " -El campo '#ListGetAt(nombre,2,'|')#' es requerido.\n";
			</cfloop>
			if(errores.length > 0){
				alert("Se presentaron los siguientes errores:\n" + errores);
				return false;
			}
			return true;
		}
		</cfif>
	</script>
</cfoutput>

<cffunction name="fnDibujarTipo" access="private" output="yes">
    <cfargument name="Name" 			type="string" 	required="true">
    <cfargument name="RHECBid" 			type="numeric" 	required="true">
    <cfargument name="RHTBDFcapturaA" 	type="numeric" 	required="true">
    <cfargument name="RHTBDFcapturaB" 	type="numeric" 	required="true">
    <cfargument name="RHTBDFnegativos"  type="boolean"  required="true">
    <cfargument name="RHDBEvalor"  		type="string"  	required="true">
    <cfargument name="RHDCBid" 			type="numeric" 	required="true">

    <cfset valorA = ""> 
	<cfif Arguments.RHTBDFcapturaA eq 5>
    	<cfset valorA = Arguments.RHDCBid>
    <cfelseif Arguments.RHTBDFcapturaA neq -1>
    	<cfif Arguments.RHTBDFcapturaB neq -1 and Arguments.RHTBDFcapturaB neq 5 and ListLen(Arguments.RHDBEvalor, '##') eq 2>
    		<cfset valorA = ListgetAt(Arguments.RHDBEvalor,1,'##')>
        <cfelse>
        	<cfset valorA = Arguments.RHDBEvalor>
        </cfif>
    </cfif>
    <cfset valorB = ""> 
	<cfif Arguments.RHTBDFcapturaB eq 5>
        <cfset valorB = Arguments.RHDCBid>
	<cfelseif Arguments.RHTBDFcapturaB neq -1>
		<cfif Arguments.RHTBDFcapturaA neq -1 and Arguments.RHTBDFcapturaA neq 5 and ListLen(Arguments.RHDBEvalor, '##') eq 2>
        	<cfset valorB = ListgetAt(Arguments.RHDBEvalor,2,'##')>
        <cfelse>
       		<cfset valorB = Arguments.RHDBEvalor>
        </cfif> 
    </cfif>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td <cfif Arguments.RHTBDFcapturaA eq 1>width="50%"<cfelse>width="5%"</cfif>>
				<cfset fnPintarTipo(Arguments.Name, Arguments.RHECBid, Arguments.RHTBDFcapturaA, Arguments.RHTBDFnegativos, valorA)>
            </td>
        <cfif Arguments.RHTBDFcapturaB neq -1>
        	<td>&nbsp;</td>
            <td>
				<cfset fnPintarTipo("B_" & Arguments.Name, Arguments.RHECBid, Arguments.RHTBDFcapturaB, Arguments.RHTBDFnegativos, valorB)>
            </td>
        </cfif>
        </tr>
    </table>
</cffunction>

<cffunction name="fnPintarTipo" access="private" output="yes">
    <cfargument name="Name" 			type="string" 	required="true">
    <cfargument name="RHECBid" 			type="numeric" 	required="true">
    <cfargument name="RHTBDFcaptura" 	type="numeric" 	required="true">
    <cfargument name="RHTBDFnegativos"  type="boolean"  required="true">
    <cfargument name="RHDBEvalor"  		type="string"  	required="true">
    <cfif Arguments.RHDBEvalor eq 'null'>
    	<cfset Arguments.RHDBEvalor = "">
    </cfif>
	<cfif Arguments.RHTBDFcaptura eq 1>
        <textarea name="RHDCBtipoValor_#Arguments.Name#" id="RHDCBtipoValor_#Arguments.Name#" rows="2" style="width: 100%;">#Arguments.RHDBEvalor#</textarea>
    <cfelseif ListFind('2,3',Arguments.RHTBDFcaptura)>
        <cfset negativos = "false">
        <cfif Arguments.RHTBDFnegativos eq 1>
            <cfset negativos = "true">
        </cfif>
        
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <cfif Arguments.RHTBDFcaptura eq 2>
                    	<cfif ListLen(Arguments.RHDBEvalor, '|') eq 2>
                    		<cfset monto = ListGetAt(Arguments.RHDBEvalor,1,'|')>
                        <cfelse>
                        	<cfset monto = 0>
                        </cfif>
                        <cf_monto name="RHDCBtipoValor_#Arguments.Name#" form = "form2" value="#replace(monto,',','','ALL')#" size="12" decimales="2" negativos="#negativos#">
                    <cfelse>
                        <cf_inputNumber name="RHDCBtipoValor_#Arguments.Name#" form = "form2" value="#Arguments.RHDBEvalor#" default="0" enteros="10" codigoNumerico="yes">
                    </cfif>
                </td>
            <cfif Arguments.RHTBDFcaptura eq 2>
            	<cfif ListLen(Arguments.RHDBEvalor, '|') eq 2>
					<cfset Mcodigo = ListGetAt(Arguments.RHDBEvalor,2,'|')>
                <cfelse>
                	<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
                        select Mcodigo from Empresas 
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    </cfquery>
                    <cfset Mcodigo = rsMonedaEmpresa.Mcodigo>
                </cfif>
                <cfquery name="rsMoneda" datasource="#session.dsn#">
                    select Mcodigo, Miso4217
                    from Monedas
                    where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
                </cfquery>
                <td>&nbsp;</td>
                <td>
                	<cfset valuesArray = ArrayNew(1)>
					<cfset ArrayAppend(valuesArray, rsMoneda.Mcodigo)>
                  	<cfset ArrayAppend(valuesArray, rsMoneda.Miso4217)>
                    <cf_conlis
                        campos="Mcodigo#Arguments.Name#, Miso4217#Arguments.Name#"
                        desplegables="N,S"
                        modificables="N,S"
                        size="0,5"
                        title="#LB_ListaDeMonedas#"
                        tabla="Monedas"
                        columnas="Mcodigo as Mcodigo#Arguments.Name#, Mnombre as Mnombre#Arguments.Name#, Miso4217 as Miso4217#Arguments.Name#, Msimbolo as Msimbolo#Arguments.Name#"
                        filtro="Ecodigo = #session.Ecodigo#"
                        desplegar="Miso4217#Arguments.Name#, Mnombre#Arguments.Name#, Msimbolo#Arguments.Name#"
                        filtrar_por="Miso4217 | Mnombre | Msimbolo"
                        filtrar_por_delimiters="|"
                        etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_Simbolo#"
                        formatos="S,S,S"
                        align="left,left,left"
                        asignar="Mcodigo#Arguments.Name#, Miso4217#Arguments.Name#"
                        asignarformatos="S,S"
                        showEmptyListMsg="true"
                        form = "form2"
                        valuesArray="#valuesArray#"
                        tabindex = "3"
                    >
                </td>
            </cfif>
            </tr>
        </table>
    <cfelseif Arguments.RHTBDFcaptura eq 4>
    	<cfif len(trim(Arguments.RHDBEvalor)) gt 0 and IsDate(Arguments.RHDBEvalor)>
			<cfset fecha = Arguments.RHDBEvalor>
        <cfelse>
			<cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
        </cfif>
        <cf_sifcalendario name="RHDCBtipoValor_#Arguments.Name#" value="#fecha#" form = "form2">
    <cfelseif Arguments.RHTBDFcaptura eq 5>
        <cfquery name="rsConcepto" datasource="#session.dsn#">
            select RHDCBid, RHDCBcodigo, RHDCBdescripcion
            from RHEConceptosBeca e
                inner join RHDConceptosBeca d
                    on d.RHECBid = e.RHECBid
            where e.RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
            order by RHDCBdescripcion, RHDCBcodigo
        </cfquery>
        <select name="RHDCBtipoValor_#Arguments.Name#" id="RHDCBtipoValor_#Arguments.Name#">
            <cfloop query="rsConcepto">
                <option value="#rsConcepto.RHDCBid#" <cfif Arguments.RHDBEvalor eq rsConcepto.RHDCBid>selected</cfif>>#trim(rsConcepto.RHDCBcodigo)#-#rsConcepto.RHDCBdescripcion#</option>
            </cfloop>
        </select>
    </cfif>
</cffunction>

</cfoutput>