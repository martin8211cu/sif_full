<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteValorYaFueAgregado"
	Default="Este valor ya fue agregado."
	returnvariable="MSG_EsteValorYaFueAgregado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empresas_Asignadas"
	Default="Empresas Asignadas"
	returnvariable="LB_Empresas_Asignadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpresas"
	Default="Lista de Empresas"
	returnvariable="LB_ListaDeEmpresas"/>
    <cf_translatedata tabla="Empresas" col="b.Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
	<cfquery name="rsEmpresasConcurso" datasource="#session.DSN#">	
        select a.RHECCid, #LvarEdescripcion# as Edescripcion, a.Ecodigo
		from RHEmpresasCorpConcurso a
           inner join Empresas b 
             on a.Ecodigo = b.Ecodigo
          where a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
          <cfif isdefined('form.externo') and form.externo eq 0>
	          and a.Ecodigo <>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
          </cfif>
	</cfquery>
<cfoutput>
<form  action="ConcursosMng-sql.cfm" method="post" name="form1">
	<table width="75%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		    	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" id="tbldynamic">
					<tr align="center" valign="middle">
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr align="center" valign="middle">
						<td align="right"><strong><cf_translate key="Empresa">Empresa</cf_translate>&nbsp;:&nbsp;</strong></td>						
						<td align="left">     
                        <cfif isdefined('form.externo') and form.externo eq 0>
                        	<cfset vFiltro = 'a.cliente_empresarial = (select b.cliente_empresarial from Empresas b where b.Ecodigo =  #Session.Ecodigo#) and a.Ecodigo <> #Session.Ecodigo# and a.Ecodigo not in (select cc.Ecodigo from RHEmpresasCorpConcurso cc where cc.RHCconcurso =  #form.RHCconcurso#)'>
                        <cfelse>
                        	<cfset vFiltro = 'a.cliente_empresarial = (select b.cliente_empresarial from Empresas b where b.Ecodigo =  #Session.Ecodigo#)  and a.Ecodigo not in (select cc.Ecodigo from RHEmpresasCorpConcurso cc where cc.RHCconcurso =  #form.RHCconcurso#)'>
                        </cfif>
                        
                                         
						<cfset ValuesArray=ArrayNew(1)>
   							<cf_translatedata tabla="Empresas" col="a.Edescripcion" name="get" returnvariable="LvarEdescripcion"/>	
                            <cf_conlis
                                Campos="Edescripcion,Ecodigo"
                                Desplegables="S,N"
                                Modificables="N"
                                Size="40"                             
                                Title="#LB_ListaDeEmpresas#"
                                Tabla="Empresas a"
                                Columnas="#LvarEdescripcion# as Edescripcion, a.Ecodigo"
                                Filtro="#vFiltro# order by Edescripcion"
                                Desplegar="Edescripcion"
                                Etiquetas="#LB_Descripcion#"
                                filtrar_por="Edescripcion"                               
                                Formatos="S"
                                Align="Left"
                                translatedatacols="Edescripcion"
                                Asignar="Edescripcion,Ecodigo"
                                Asignarformatos="S,I"
                                tabindex="1" /> 
                        
                      </td>
						<td>&nbsp;</td>
						<td>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Agregar"
								Default="Agregar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Agregar"/>

						<!---	<input type="button" name="<cfoutput>#BTN_Agregar#</cfoutput>" align="middle" value="+" 
							onClick="javascript: habilitarValidacionMas(); if (objForm.validate()) fnNuevoTR();">--->
						</td>
				  </tr>
				  <tr>
                     <td colspan="4">&nbsp;<input name="tab" type="hidden" value="#Form.tab#">
                     <input name="RHCconcurso" type="hidden" value="#Form.RHCconcurso#"></td>
                     </tr>
				  <tbody>
				  </tbody>
				</table>		
			<cfif not isdefined("Form.tab")>
				</fieldset>
			</cfif>
		</td>
		<td>&nbsp;</td>		
	</tr>
</table>
	<br>
	<cf_botones modo="Alta,Atras" exclude="Baja,Nuevo">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
	</cfinvoke>
	<input name="ts_rversion" type="hidden" value="#ts#">
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
</cfoutput>
</form>
<table align="center" width="30%">
	<tr>
		<td align="center">
		  <table align="center" width="100%" border="0">
		    <tr>
		     <td align="center" colspan="2">
		       <strong><cfoutput>#LB_Empresas_Asignadas#</cfoutput></strong>  
		     </td>
		    </tr> 
		 
		    <cfif rsEmpresasConcurso.recordcount>
			    <form action="ConcursosMng-sql.cfm" method="post" name="formListaEmpresas">	
				  	<cfoutput query="rsEmpresasConcurso">
				      	<tr class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
							onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';"
							style="cursor:pointer;">
					        <td nowrap>#Edescripcion#</td>
							<td>
								<img src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" onClick="document.nosubmit=true; if (!confirm('<cf_translate key="LB_DeseaEliminarElRegistro" xmlFile="generales.xml">¿Desea eliminar el registro?</cf_translate>')) return false;       
					            document.formListaEmpresas.Baja.value='Baja';
					            document.formListaEmpresas.RHECCid.value='#RHECCid#'; 
					            document.formListaEmpresas.RHCconcurso.value='#Form.RHCconcurso#';      
					            document.formListaEmpresas.tab.value='#Form.tab#';   
					            document.formListaEmpresas.submit();">
					        </td>		
				    	</tr>
			    	</cfoutput>
					<input name="tab"         type="hidden" id="tab">
				    <input name="RHCconcurso" type="hidden" id="RHCconcurso">
				    <input name="Baja"        type="hidden" id="Baja">
				    <input name="RHECCid"     type="hidden" id="RHECCid">
			  	</form>
		  	<cfelse>
			  <tr><td align="center" ><strong>-- <cf_translate key="LB_NoSeEncontraronRegistros" xmlFile="generales.xml">No se encontraron registros</cf_translate> --</strong></td></tr>
		  	</cfif>
		  </table>
		</td>
	</tr>
</table>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSehaSeleccionadoUnaEmpresa"
	Default="No se ha seleccionado una Empresa. Verifique."
	returnvariable="MSG_NoSehaSeleccionadoUnaEmpresa"/>
    
    
<cf_qforms form="form1">
<script language="javascript" type="text/javascript">
	function funcAlta(){
		var Empresa = document.form1.Ecodigo.value;
		if (Empresa == ""){
			alert('<cfoutput>#MSG_NoSehaSeleccionadoUnaEmpresa#</cfoutput>');
			return false;
		}else{
			return true;
		}
	}
</script>
