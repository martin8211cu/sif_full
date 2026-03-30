<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consultas"
	Default="Consultas"
	returnvariable="LB_Consultas"/>
    
    <cfif isdefined("Url.Reporte") and not isdefined("Form.Reporte")>
        <cfparam name="Form.Reporte" default="#Url.Reporte#">
    </cfif>
    <cfif  not isdefined("Url.Reporte") and not isdefined("Form.Reporte")>
        <cfparam name="Form.Reporte" default="1">
    </cfif>

	<cf_templatearea name="title">
		<cfoutput>#LB_title#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cfinclude template="../../../sif/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<cfset regresar = "/cfmx/hosting/tratado/index.cfm">
            <tr><td><cfinclude template="../../../sif/portlets/pNavegacion.cfm"></td></tr>

            <tr>
				<td valign="top">
					 <cf_web_portlet_start border="true" titulo="<cfoutput>#LB_Consultas#</cfoutput>" skin="#Session.Preferences.Skin#">
                    	<table width="100%" cellpadding="2" cellspacing="0">
                    		<tr>
                        		<td valign="top">
                                    <form style="margin:0" name="form1" method="post"  action="Consultas.cfm"  onSubmit="return validar();" >
                                        <table width="100%" cellpadding="2" cellspacing="0">
                                            <tr>
                                                <td width="9%">
                                                    <font  style="font-size:10px"><cf_translate key="LB_Reportes">Reportes</cf_translate></font>
                                                </td>
                                                <td>
                                                    <select name="Reporte" id="Reporte" style="font-size:10px" tabindex="1"  onChange="document.form1.submit();">
                                                        <option value="1" <cfif isdefined("form.Reporte") and form.Reporte EQ 1> selected</cfif>><cf_translate key="LB_Busqueda_Por_Referencias">Busqueda Por Referencias</cf_translate></option>
                                                        <option value="2" <cfif isdefined("form.Reporte") and form.Reporte EQ 2> selected</cfif>><cf_translate key="LB_Personas_por_Empresa">Personas por Empresa</cf_translate></option>
														<option value="3" <cfif isdefined("form.Reporte") and form.Reporte EQ 3> selected</cfif>><cf_translate key="LB_Personas_por_Empresa_Distrito_Electoral">Personas por Empresa (Distrito Electoral)</cf_translate></option>
                                                    </select>
                                                </td>
                                            
                                            </tr>
                                        </table>
                            		</form>
                                 </td>
                        	</tr>
                            <cfif form.Reporte eq 1>
                                 <tr>
                                    <td valign="top" >
                                    <form style="margin:0" name="formrep1" method="get"  action="Reporte1SQL.cfm"   >
                                            <cfinvoke component="sif.Componentes.Translate"
                                            method="Translate"
                                            key="LB_Limpiar"
                                            Default="Limpiar"
                                            returnvariable="LB_Limpiar"/>
                                            
                                            <cfinvoke component="sif.Componentes.Translate"
                                            method="Translate"
                                            key="LB_Referencias"
                                            Default="Referencias"
                                            returnvariable="LB_Referencias"/>
                                            
                                             <table  id="tbldynamic" width="100%" cellpadding="2" cellspacing="0">
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Formato">Formato</cf_translate></font>
                                                    </td>
                                                    <td colspan="2">
                                                        <select name="Formato" id="Formato" style="font-size:10px" tabindex="1">
                                                            <option value="1" <cfif isdefined("form.Formato") and form.Formato EQ 1> selected</cfif>><cf_translate key="LB_HTML_Excel">HTML / Excel</cf_translate></option>
                                                            <option value="2" <cfif isdefined("form.Formato") and form.Formato EQ 2> selected</cfif>><cf_translate key="LB_Adobe_PDF">Adobe PDF</cf_translate></option>
                                                            <option value="3" <cfif isdefined("form.Formato") and form.Formato EQ 3> selected</cfif>><cf_translate key="LB_FlashPaper">FlashPaper</cf_translate></option>
    
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Tipo">Tipo</cf_translate></font>
                                                    </td>
                                                    <td colspan="2">
                                                        <select name="Tipo" id="Tipo" style="font-size:10px" tabindex="1">
                                                            <option value="2" <cfif isdefined("form.Tipo") and form.Tipo EQ 2> selected</cfif>><cf_translate key="LB_Tabular">Tabular</cf_translate></option>
                                                            <option value="1" <cfif isdefined("form.Tipo") and form.Tipo EQ 1> selected</cfif>><cf_translate key="LB_Listado">Listado</cf_translate></option>
                                                            
                                                        </select>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Referencia">Referencia</cf_translate></font>
                                                    </td>
                                                    <td colspan="2">
                                                        <cfset ArrayReferencia=ArrayNew(1)>
                                                        <cfif isdefined("form.ETLCreferencia") and len(trim(form.ETLCreferencia))>
                                                            <cfset ArrayAppend(ArrayEmpresa,form.ETLCreferencia)>
                                                        </cfif>
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Referencia"
                                                        Default="Referencia"
                                                        returnvariable="LB_Referencia"/>
                                                        
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Referencias"
                                                        Default="Referencias"
                                                        returnvariable="LB_Referencias"/>

                                                        <cf_conlis
                                                            Campos="ETLCreferencia"
                                                            Desplegables="S"
                                                            Modificables="S"
                                                            Size="40"
                                                            tabindex="1"
                                                            ValuesArray="#ArrayReferencia#" 
                                                            Title="#LB_Referencias#"
                                                            Tabla="EmpresasTLC"
                                                            Columnas="distinct  ETLCreferencia"
                                                            Desplegar="ETLCreferencia"
                                                            Etiquetas="#LB_Referencia#"
                                                            filtrar_por="ETLCreferencia"
                                                            Filtro=" ETLCespecial != 1 and ETLCreferencia is not null"
                                                            Formatos="S"
                                                            Align="left"
                                                            funcion="limpiaempresa"
                                                            form="formrep1"
                                                            Asignar="ETLCreferencia"
                                                            Asignarformatos="S"/>
                                                    </td>  
                                                </tr>
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Empresa">Empresa</cf_translate></font>
                                                    </td>
                                                    <td  width="40%">
                                                        <cfset ArrayEmpresa=ArrayNew(1)>
                                                        <cfif isdefined("form.ETLCid") and len(trim(form.ETLCid))>
                                                            <cfquery name="rsEmpresas" datasource="#session.DSN#">
                                                                select ETLCid,ETLCpatrono,ETLCnomPatrono
                                                                from EmpresasTLC
                                                                where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#"> 
                                                                and   ETLCreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETLCreferencia#"> 
                                                            </cfquery>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCid)>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCpatrono)>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCnomPatrono)>
                                                        </cfif>
                                                        
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Nombre"
                                                        Default="Nombre"
                                                        returnvariable="vNombre"/>
                                                        
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Cedula_Juridica"
                                                        Default="C&eacute;dula Juridica"
                                                        returnvariable="LB_Cedula_Juridica"/> 
                                                        
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Lista_de_Empresas"
                                                        Default="Lista de Empresas"
                                                        returnvariable="LB_Lista_de_Empresas"/>                                                        
                                                                                    
                                                        
                                                       <cf_conlis
														Campos="ETLCid,ETLCpatrono,ETLCnomPatrono"
														Desplegables="N,S,S"
														Modificables="N,S,N"
														Size="0,10,60"
														tabindex="1"
														ValuesArray="#ArrayEmpresa#" 
														Title="#LB_Lista_de_Empresas#"
														Tabla="EmpresasTLC"
														Columnas="ETLCid,ETLCpatrono,ETLCnomPatrono"
														Desplegar="ETLCpatrono,ETLCnomPatrono"
														Etiquetas="#LB_Cedula_Juridica#,#vNombre#"
														filtrar_por="ETLCpatrono,ETLCnomPatrono"
                                                        Filtro="ETLCreferencia = $ETLCreferencia,varchar$"
														Formatos="S,S"
                                                        
														Align="left,left"
														form="formrep1"
														Asignar="ETLCid,ETLCpatrono,ETLCnomPatrono"
														Asignarformatos="S,S,S"/>
                                                    </td>  
                                                    <td >
                                                      <input type="button" name="Agregar" value="+" onClick="javascript: fnNuevaRefTR();" />
                                                    </td>                                              
                                                </tr>
                                            </table>
                                            <table  align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                 <tr>
                                                    <td  align="center"  colspan="3">
                                                    <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Limpiar"
                                                        Default="Limpiar"
                                                        returnvariable="LB_Limpiar"/>
                                                        
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Imprimir"
                                                        Default="Imprimir"
                                                        returnvariable="LB_Imprimir"/>
                                                    
                                                        <input name="btnNuevoLista" class="btnNuevo" type="reset" value='<cfoutput>#LB_Limpiar#</cfoutput>'>
                                                        <input name="btnImportar" class="btnNuevo" type="submit" value='<cfoutput>#LB_Imprimir#</cfoutput>'>
                                                     </td>   
                                                 </tr>
                                            </table> 
                                            <input type="hidden" name="LastOne" id="LastOne" value="">
                                            <input type="hidden" name="contador" id="contador" value="0">
                                            <cfinvoke component="sif.Componentes.Translate"
                                            method="Translate"
                                            key="LB_Eliminar_referencia"
                                            Default="Eliminar referencia"
                                            returnvariable="LB_Eliminar_referencia"/>
                                            
                                            <input type="image" id="imgDel" src="/cfmx/sif/imagenes/Borrar01_S.gif" title='<cfoutput>#LB_Eliminar_referencia#</cfoutput>' style="display:none;">
    
                                        </form>
                                    </td>
                                </tr>
                            <cfelseif  form.Reporte eq 2>
                                <tr>
                                    <td>
                                    <form style="margin:0" name="formrep2" method="get"  action="Reporte2SQL.cfm" >
                                            <table id="tbldynamic" width="100%" cellpadding="2" cellspacing="0" s>
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Formato">Formato</cf_translate></font>
                                                    </td>
                                                    <td colspan="2">
                                                        <select name="Formato" id="Formato" style="font-size:10px" tabindex="1">
                                                            <option value="1" <cfif isdefined("form.Formato") and form.Formato EQ 1> selected</cfif>><cf_translate key="LB_HTML_Excel">HTML / Excel</cf_translate></option>
                                                            <option value="2" <cfif isdefined("form.Formato") and form.Formato EQ 2> selected</cfif>><cf_translate key="LB_Adobe_PDF">Adobe PDF</cf_translate></option>
                                                            <option value="3" <cfif isdefined("form.Formato") and form.Formato EQ 3> selected</cfif>><cf_translate key="LB_FlashPaper">FlashPaper</cf_translate></option>
    
                                                        </select>
                                                    </td>
                                                </tr>  
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Ver">Ver</cf_translate></font>
                                                    </td>
                                                    <td colspan="2">
                                                        <select name="Ver" id="Ver" style="font-size:10px" tabindex="1">
                                                            <option value="" ><cf_translate key="LB_Todos">Todos</cf_translate></option>
                                                            <option value="1" <cfif isdefined("form.Ver") and form.Ver EQ 1> selected</cfif>><cf_translate key="LB_Sincronizados">Sincronizados</cf_translate></option>
                                                            <option value="0" <cfif isdefined("form.Ver") and form.Ver EQ 0> selected</cfif>><cf_translate key="LB_No_Sincronizados">No Sincronizados</cf_translate></option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                                                          
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Empresa">Empresa</cf_translate></font>
                                                    </td>
                                                    <td width="40%">
														<cfset ArrayEmpresa=ArrayNew(1)>
                                                        <cfif isdefined("form.ETLCid") and len(trim(form.ETLCid))>
                                                            <cfquery name="rsEmpresas" datasource="#session.DSN#">
                                                                select ETLCid,ETLCpatrono,ETLCnomPatrono
                                                                from EmpresasTLC
                                                                where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#"> 
                                                            </cfquery>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCid)>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCpatrono)>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCnomPatrono)>
                                                        </cfif>
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                            method="Translate"
                                                            key="LB_Cedula_Juridica"
                                                            Default="C&eacute;dula Juridica"
                                                            returnvariable="LB_Cedula_Juridica"/> 
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                            method="Translate"
                                                            key="LB_Nombre"
                                                            Default="Nombre"
                                                            returnvariable="vNombre"/> 
                                                         
                                                         <cfinvoke component="sif.Componentes.Translate"
                                                            method="Translate"
                                                            key="LB_Lista_de_Empresas"
                                                            Default="Lista de Empresas"
                                                            returnvariable="LB_Lista_de_Empresas"/>   
                                                            
                                                        
                                                        <cf_conlis
                                                            Campos="ETLCid,ETLCpatrono,ETLCnomPatrono"
                                                            Desplegables="N,S,S"
                                                            Modificables="N,S,N"
                                                            Size="0,10,60"
                                                            tabindex="1"
                                                            ValuesArray="#ArrayEmpresa#" 
                                                            Title="#LB_Lista_de_Empresas#"
                                                            Tabla="EmpresasTLC"
                                                            Columnas="ETLCid,ETLCpatrono,ETLCnomPatrono,ETLCespecial"
                                                            Desplegar="ETLCpatrono,ETLCnomPatrono"
                                                            Etiquetas="#LB_Cedula_Juridica#,#vNombre#"
                                                            filtrar_por="ETLCpatrono,ETLCnomPatrono"
                                                            Filtro=" ETLCespecial != 1"
                                                            Formatos="S,S"
                                                            Align="left,left"
                                                            form="formrep2"
                                                            Asignar="ETLCid,ETLCpatrono,ETLCnomPatrono"
                                                            Asignarformatos="S,S,S"/>                                                    
                                                    </td>
                                                    <td >
                                                    </td>                                              
                                                </tr>
                                            </table>
                                            <table  align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                 <tr>
                                                    <td  align="center"  colspan="3">
                                                    <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Limpiar"
                                                        Default="Limpiar"
                                                        returnvariable="LB_Limpiar"/>
                                                        
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Imprimir"
                                                        Default="Imprimir"
                                                        returnvariable="LB_Imprimir"/>
                                                    
                                                        <input name="btnNuevoLista" class="btnNuevo" type="reset" value='<cfoutput>#LB_Limpiar#</cfoutput>'>
                                                        <input name="btnImportar" class="btnNuevo" type="submit" value='<cfoutput>#LB_Imprimir#</cfoutput>'>
                                                     </td>   
                                                 </tr>
                                            </table> 
                                            <cfinvoke component="sif.Componentes.Translate"
                                            method="Translate"
                                            key="LB_Eliminar_referencia"
                                            Default="Eliminar referencia"
                                            returnvariable="LB_Eliminar_referencia"/>
                                        </form>
                                    </td>
                                </tr>
							<cfelseif  form.Reporte eq 3>
                                <tr>
                                    <td>
                                    <form style="margin:0" name="formrep3" method="get"  action="Reporte3SQL.cfm" >
                                            <table id="tbldynamic" width="100%" cellpadding="2" cellspacing="0" s>
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Formato">Formato</cf_translate></font>
                                                    </td>
                                                    <td colspan="2">
                                                        <select name="Formato" id="Formato" style="font-size:10px" tabindex="1">
                                                            <option value="1" <cfif isdefined("form.Formato") and form.Formato EQ 1> selected</cfif>><cf_translate key="LB_HTML_Excel">HTML / Excel</cf_translate></option>
                                                            <option value="2" <cfif isdefined("form.Formato") and form.Formato EQ 2> selected</cfif>><cf_translate key="LB_Adobe_PDF">Adobe PDF</cf_translate></option>
                                                            <option value="3" <cfif isdefined("form.Formato") and form.Formato EQ 3> selected</cfif>><cf_translate key="LB_FlashPaper">FlashPaper</cf_translate></option>
    
                                                        </select>
                                                    </td>
                                                </tr>  
                                                <tr>
                                                    <td width="10%">
                                                        <font  style="font-size:10px"><cf_translate key="LB_Empresa">Empresa</cf_translate></font>
                                                    </td>
                                                    <td width="40%">
														<cfset ArrayEmpresa=ArrayNew(1)>
                                                        <cfif isdefined("form.ETLCid") and len(trim(form.ETLCid))>
                                                            <cfquery name="rsEmpresas" datasource="#session.DSN#">
                                                                select ETLCid,ETLCpatrono,ETLCnomPatrono
                                                                from EmpresasTLC
                                                                where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#"> 
                                                            </cfquery>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCid)>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCpatrono)>
                                                            <cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCnomPatrono)>
                                                        </cfif>
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                            method="Translate"
                                                            key="LB_Cedula_Juridica"
                                                            Default="C&eacute;dula Juridica"
                                                            returnvariable="LB_Cedula_Juridica"/> 
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                            method="Translate"
                                                            key="LB_Nombre"
                                                            Default="Nombre"
                                                            returnvariable="vNombre"/> 
                                                         
                                                         <cfinvoke component="sif.Componentes.Translate"
                                                            method="Translate"
                                                            key="LB_Lista_de_Empresas"
                                                            Default="Lista de Empresas"
                                                            returnvariable="LB_Lista_de_Empresas"/>   
                                                            
                                                        
                                                        <cf_conlis
                                                            Campos="ETLCid,ETLCpatrono,ETLCnomPatrono"
                                                            Desplegables="N,S,S"
                                                            Modificables="N,S,N"
                                                            Size="0,15,60"
                                                            tabindex="1"
                                                            ValuesArray="#ArrayEmpresa#" 
                                                            Title="#LB_Lista_de_Empresas#"
                                                            Tabla="EmpresasTLC"
                                                            Columnas="ETLCid,ETLCpatrono,ETLCnomPatrono,ETLCespecial"
                                                            Desplegar="ETLCpatrono,ETLCnomPatrono"
                                                            Etiquetas="#LB_Cedula_Juridica#,#vNombre#"
                                                            filtrar_por="ETLCpatrono,ETLCnomPatrono"
                                                            Filtro=" ETLCespecial != 1"
                                                            Formatos="S,S"
                                                            Align="left,left"
                                                            form="formrep3"
                                                            Asignar="ETLCid,ETLCpatrono,ETLCnomPatrono"
                                                            Asignarformatos="S,S,S"/>                                                    
                                                    </td>
                                                    <td >
                                                    </td>                                              
                                                </tr>
                                            </table>
                                            <table  align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                 <tr>
                                                    <td  align="center"  colspan="3">
                                                    <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Limpiar"
                                                        Default="Limpiar"
                                                        returnvariable="LB_Limpiar"/>
                                                        
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        key="LB_Imprimir"
                                                        Default="Imprimir"
                                                        returnvariable="LB_Imprimir"/>
                                                    
                                                        <input name="btnNuevoLista" class="btnNuevo" type="reset" tabindex="1" value='<cfoutput>#LB_Limpiar#</cfoutput>'>
                                                        <input name="btnImportar" class="btnNuevo" type="submit" tabindex="1" value='<cfoutput>#LB_Imprimir#</cfoutput>'>
                                                     </td>   
                                                 </tr>
                                            </table> 
                                            <cfinvoke component="sif.Componentes.Translate"
                                            method="Translate"
                                            key="LB_Eliminar_referencia"
                                            Default="Eliminar referencia"
                                            returnvariable="LB_Eliminar_referencia"/>
                                        </form>
                                    </td>
                                </tr>
							</cfif>
                      	</table>      
					<cf_web_portlet_end>
            </td>	
        </tr>
    </table>	
</cf_templatearea>
</cf_template>


<cfif form.Reporte eq 1>
	<cf_qforms form="formrep1">

    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    key="LB_Seleccione_una_Referencia_y_una_empresa"
    Default="Seleccione una referencia y una empresa"
    returnvariable="LB_Seleccione_una_Referencia_y_una_empresa"/>
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    key="LB_Agregar_una_Referencia_y_una_empresa"
    Default="Agregar una referencia y una empresa"
    returnvariable="LB_Agregar_una_Referencia_y_una_empresa"/>
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    key="MSG_EsteValorYaFueAgregado"
    Default="Este valor ya fue agregado"
    returnvariable="MSG_EsteValorYaFueAgregado"/>    
    
<cfelseif  form.Reporte eq 2>    
	<cf_qforms form="formrep2">
     
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    key="LB_Empresa"
    Default="Empresa"
    returnvariable="LB_Seleccione_una_empresa"/>    
<cfelseif  form.Reporte eq 3>    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    key="LB_Empresa"
    Default="Empresa"
    returnvariable="LB_Seleccione_una_empresa"/>     
    <cf_qforms form="formrep3" objForm="oformrep3">
		<cf_qformsrequiredfield name="ETLCid" description="#LB_Seleccione_una_empresa#"/>					
	</cf_qforms>
</cfif>



<script language="javascript" type="text/javascript">
	<cfif form.Reporte eq 1>
		objForm.contador.required = true;
		objForm.contador.description="<cfoutput>#LB_Agregar_una_Referencia_y_una_empresa#</cfoutput>";
		
		function limpiaempresa(){
			document.formrep1.ETLCid.value = "";
			document.formrep1.ETLCpatrono.value = "";
			document.formrep1.ETLCnomPatrono.value = "";
		}

	
		function fnNuevaRefTR(){
		  var LvarTable = document.getElementById("tbldynamic");
		 
		  var LvarTbody = LvarTable.tBodies[0];
		 
		
		  var LvarTR    = document.createElement("TR");
		


		  
		  var Lclass 	= document.formrep1.LastOne;
		  var Cantidad = new Number(document.formrep1.contador.value);
 
		  var p1 		= document.formrep1.ETLCid.value;//id
		  var p2 		= document.formrep1.ETLCreferencia.value;//cod
		  var p3 		= '( ' +document.formrep1.ETLCreferencia.value +' ) '+ document.formrep1.ETLCnomPatrono.value;//descripcion
		  

		  
		  // Valida no agregar vacos
		  if (p1=="" || p2=="") {
		  alert('<cfoutput>#LB_Seleccione_una_Referencia_y_una_empresa#</cfoutput>')
		  return;
		  }

	  
		  if (existeCodigo(p1+'|'+p2)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}
	
	 		  		  		  		

		  // Agrega Columna 1
		  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "RHCGidList");

		  // Agrega Columna 2
		  sbAgregaTdText  (LvarTR, Lclass.value, p3 );
		 // Agrega Evento de borrado
	
		 
		  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel");
		  if (document.all)
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		  else
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		

		  // Nombra el TR
		  LvarTR.name = "XXXXX";
		  
		  // Agrega el TR al Tbody
		  LvarTbody.appendChild(LvarTR);
			  
		  if (Lclass.value=="ListaNon")
			Lclass.value="ListaPar";
		  else
			Lclass.value="ListaNon";
		 Cantidad = Cantidad + 1;
		 document.formrep1.contador.value = Cantidad; 
		}	
		
	//Funcin para eliminar TRs
	function sbEliminarTR(e)
	{
	  var Cantidad = new Number(document.formrep1.contador.value);

	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	  Cantidad = Cantidad - 1;
	  
	 if ( Cantidad <= 0)
		document.formrep1.contador.value = "";
	 else
		document.formrep1.contador.value = Cantidad;

	}
	
	//Funcin para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Funcin para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Funcin para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	function existeCodigo(v){
		var LvarTable = document.getElementById("tbldynamic");
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			var  valor = fnTdValue(LvarTable.rows[i]);
			
			if (valor==v){
				return true;
			}
		}
		return false;
	}
	
	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}	  
		
<cfelseif  form.Reporte eq 2>
	objForm.ETLCid.required = true;
	objForm.ETLCid.description="<cfoutput>#LB_Seleccione_una_empresa#</cfoutput>";
</cfif>

</script>