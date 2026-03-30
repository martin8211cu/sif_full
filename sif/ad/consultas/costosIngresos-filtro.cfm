<cf_templateheader title="Consulta de Costos e Ingresos">
    <cf_web_portlet_start border="true" titulo="Consulta de Costos e Ingresos" >
        <cfif isdefined("url.empresa") and not isdefined("form.empresa") >
			<cfset form.empresa = url.empresa >
        </cfif>
        <cfif isdefined("url.fCFid") and not isdefined("form.fCFid") >
            <cfset form.fCFid = url.fCFid >
        </cfif>
        <cfif isdefined("url.Cid") and not isdefined("form.Cid") >
            <cfset form.Cid = url.Cid >
        </cfif>
        <cfif isdefined("url.Cid2") and not isdefined("form.Cid2") >
            <cfset form.Cid2 = url.Cid2 >
        </cfif>
        <cfif isdefined("url.IngPorc") and not isdefined("form.IngPorc") >
            <cfset form.IngPorc = url.IngPorc >
        </cfif>
        
        <form style="margin:0" action="costosIngresos.cfm" method="post" name="form1" id="form1" >
        <table align="center" border="0" cellspacing="0" cellpadding="4" width="90%" >
            <tr>
                <td align="right" valign="middle" width="1" nowrap="nowrap"><strong>Empresa:</strong></td>
                <td>
                    <cfquery name="rsEmpresa" datasource="#session.DSN#">
                        select 	
                            Ecodigo, 
                            Edescripcion as Enombre
                        from Empresas
                        where cliente_empresarial = #session.CEcodigo#
                        order by Enombre
                    </cfquery>
                    <select name="empresa">
                        <option value=""></option>
                        <cfloop query="rsEmpresa">
                            <cfoutput><option value="#rsEmpresa.Ecodigo#" <cfif isdefined("form.empresa") and form.empresa eq rsEmpresa.Ecodigo>selected</cfif>>#rsEmpresa.Enombre#</option></cfoutput>
                        </cfloop>
                    </select>
                </td>
            </tr>
            
            <tr>
                <td align="right" valign="middle" ><strong>Centro Funcional:</strong></td>
                <td>
                    <cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
                        <cfquery name="rscfuncional" datasource="#Session.DSN#">
                            select CFid as fCFid, CFcodigo, CFdescripcion 
                            from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                            and CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
                        </cfquery>
                        <cf_rhcfuncional id="fCFid" form="form1" query="#rscfuncional#">
                    <cfelse>
                        <cf_rhcfuncional id="fCFid" form="form1">
                    </cfif>
                </td>
            </tr>
    
            <tr >
                <td align="right" valign="middle" id="tr_rol1"><strong>Costo:</strong></td>
                <td id="tr_rol2">
                	<cfset ValuesArray=ArrayNew(1)>
					<cfif isdefined("form.Cid") and form.Cid gt 0>
                    	<cfquery name="Costo" datasource="#session.dsn#">
                        	select Ccodigo, Cdescripcion, Cid, Cporc
                            from Conceptos
                            where Ecodigo = #session.Ecodigo#
                            and Cid = #form.Cid#
                        </cfquery>
                        <cfset ArrayAppend(ValuesArray,Costo.Ccodigo)>
                        <cfset ArrayAppend(ValuesArray,Costo.Cdescripcion)>
                        <cfset ArrayAppend(ValuesArray,Costo.Cid)>
                    </cfif>
                    <cf_conlis title="Lista de Costos"
                    campos = "Ccodigo, Cdescripcion, Cid, Cporc" 
                    ValuesArray="#ValuesArray#"
                    desplegables = "S,S,N,N" 
                    modificables = "S,N,N,N" 
                    size = "10,40,0,0"
                    asignar="Ccodigo, Cdescripcion, Cid, Cporc"
                    asignarformatos="S,S,S"
                    tabla="Conceptos c"																	
                    columnas="c.Ccodigo, c.Cdescripcion, c.Cid, c.Cporc"
                    filtro="c.Ecodigo = #session.Ecodigo#
                                and c.Ctipo = 'G'
                                and coalesce(c.Cporc,0) > 0"
                    desplegar="Ccodigo, Cdescripcion, Cporc"
                    etiquetas="Código, Descripcion, Porcentaje"
                    formatos="S,S,V"
                    align="left,left,left"
                    showEmptyListMsg="true"
                    form="form1"
                    width="800"
                    height="500"
                    >
                </td>
            </tr>
    
            <tr >
                <td align="right" valign="middle" id="tr_modulo1" ><strong>Ingreso:</strong></td>
                <td id="tr_modulo2">
                	<cfset ValuesArrayI=ArrayNew(1)>
					<cfif isdefined("form.Cid2") and form.Cid2 gt 0>
                    	<cfquery name="Ingreso" datasource="#session.dsn#">
                        	select Ccodigo, Cdescripcion, Cid, Cporc
                            from Conceptos
                            where Ecodigo = #session.Ecodigo#
                            and Cid = #form.Cid2#
                        </cfquery>
                        <cfset ArrayAppend(ValuesArrayI,Ingreso.Ccodigo)>
                        <cfset ArrayAppend(ValuesArrayI,Ingreso.Cdescripcion)>
                        <cfset ArrayAppend(ValuesArrayI,Ingreso.Cid)>
                    </cfif>
                    <cf_conlis title="Lista de Ingresos"
                    campos = "Ccodigo2, Cdescripcion2, Cid2, Cporc2" 
                    ValuesArray="#ValuesArrayI#"
                    desplegables = "S,S,N,N" 
                    modificables = "S,N,N,N" 
                    size = "10,30,0"
                    asignar="Ccodigo2, Cdescripcion2, Cid2, Cporc2"
                    asignarformatos="S,S,S"
                    tabla="Conceptos c"																	
                    columnas="c.Ccodigo as Ccodigo2, c.Cdescripcion as Cdescripcion2, c.Cid as Cid2, c.Cporc as Cporc2"
                    filtro="c.Ecodigo = #session.Ecodigo#
                                and c.Ctipo = 'I'"
                    filtrar_por="Ccodigo, Cdescripcion"            
                    desplegar="Ccodigo2, Cdescripcion2"
                    etiquetas="Código, Descripción"
                    formatos="S,S,V"
                    align="left,left,left"
                    showEmptyListMsg="true"
                    form="form1"
                    width="800"
                    height="500"
                    >
                </td>
            </tr>
    
            <tr >
                <td align="right" valign="middle" id="tr_proceso2" ><strong>Porcentaje:</strong></td>
                <td id="tr_proceso1">
                	<input id="IngPorc" name="IngPorc" type="text" size="9" maxlength="9" value="" 
                    onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
                    onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                    alt="Porcentaje"> %
                </td>
            </tr>                
            <tr>	
                <td align="right" valign="middle" width="40%"><strong>&nbsp;</strong></td>
			</tr>
            <tr>
                <td colspan="3" align="center"><input type="submit" name="btnConsultar" value="Consultar" class="btnConsulta" /></td>
            </tr>
        </table>
    </form>
    <cf_web_portlet_end>
<cf_templatefooter>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>

<script type="text/javascript" language="javascript1.2">
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	
	// Funcion para validar que el porcentaje digitado no sea mayor a100
	function _mayor(){	
		if ( new Number(qf(this.value)) > 100 ){
			this.error = 'El campo no puede ser mayor a 100';
			this.value = '';
		}
	}
	
	// Validaciones para los campos de % no sean mayores a 100 		
	_addValidator("ismayor", _mayor);
	
	objForm.IngPorc.validatemayor();	
	objForm.IngPorc.validate = true;
	
</script>
