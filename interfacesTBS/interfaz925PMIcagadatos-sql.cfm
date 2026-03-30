<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generación de Nóminas'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<!---<cf_navegacion name="NNomina" 		navegacion="" session default="">
<cf_navegacion name="CNomina" 		navegacion="" session default="">
<cf_navegacion name="LvarTipo" 		navegacion="" session default="">
--->
<cfset varNavegacion = ''>
<cfif isdefined("url.PageNum_lista") and len(trim(url.PageNum_lista)) GT 0>
	<cfset varNavegacion = varNavegacion & "&pagina=#url.PageNum_lista#">
<cfelse>
	<cfset varNavegacion = varNavegacion & "&pagina=1">
</cfif>
<cfsetting enablecfoutputonly="yes">

<cfoutput>
<!---
	<cfset LvarTipo = ''>
	<cfif isdefined("form.NNomina") and len(trim(form.NNomina))>
		<cfset LvarTipo = 'N'>
	</cfif>
	<cfif isdefined("form.CNomina") and len(trim(form.CNomina))>
		<cfset LvarTipo = 'C'>
	</cfif>
	<cfif isdefined("form.LvarTipo") and len(trim(form.LvarTipo))>
		<cfset TipoNom = form.LvarTipo>
	</cfif>

	<!---<cfset varNavegacion = varNavegacion & "&LvarTipo=#LvarTipo#&LvarSocioN=#LvarSocioN#">--->	
<!---	<cfthrow message=" Nueva #LvarTipo2# cancelacion #LvarTipo1#">--->
	<cfthrow message="Tipo #LvarTipo#">
	<cfset varNavegacion = #LvarTipo#>--->
	
	<cfquery name="rsNominas" datasource="sifinterfaces">
			select ltrim(rtrim(PMI_GL_COD_EJEC)) as PMI_GL_COD_EJEC, 
			PMI_GL_DESCRIPCION, 
			PMI_GL_FECHA_EMISI, 
			PMI_GL_COD_EJEC_REF, 
			PMI_GL_CANCELACION,
			Cancelacion = case PMI_GL_CANCELACION when 'Y' then 'SI' when 'N' then 'NO' end  
			from 
			PS_PMI_GL_HEADER_2
	</cfquery>

	<cfif rsNominas.recordcount GT 0>
	<cfquery datasource="sifinterfaces">
		delete PS_PMI_GL_HEADER
	</cfquery>
	<cfloop query="rsNominas">
		<!---Inserta el encabezado de la Nomina en una tabla temporal--->
		<cfquery datasource="sifinterfacessybase">
			insert into PS_PMI_GL_HEADER_2( 
						PMI_GL_COD_EJEC, 
						PMI_GL_DESCRIPCION, 
						PMI_GL_FECHA_EMISI, 
						PMI_GL_COD_EJEC_REF, 
						PMI_GL_CANCELACION)
				values ('#rsNominas.PMI_GL_COD_EJEC#',
						'#rsNominas.PMI_GL_DESCRIPCION#',
						'#rsNominas.PMI_GL_FECHA_EMISI#',
						'#rsNominas.PMI_GL_COD_EJEC_REF#',
						'#rsNominas.PMI_GL_CANCELACION#')
		</cfquery>
	
		<cfquery name = "rsDNominas" datasource="sifinterfaces">
			select PMI_GL_COD_EJEC, PMI_GL_LINEA, PMI_GL_RUBRO, PMI_GL_SUBRUBRO, PMI_GL_EMPLEADO, PMI_GL_DESCRIPCION,
			   PMI_GL_TIPO, PMI_GL_IMPORTE, PMI_GL_CTRO_COSTOS, PMI_GL_CUENTA
      		   from PS_PMI_GL_DET_NOM_2
			   where PMI_GL_COD_EJEC = '#rsNominas.PMI_GL_COD_EJEC#'
		</cfquery>
	
		<cfif isdefined("rsDNominas") and recordcount GT 0>
		<cfquery datasource="sifinterfaces">
			delete PS_PMI_GL_DET_NOM
		</cfquery>
		<cfloop query="rsDNominas">
			<!---Inserta los detalles de la Nómina en una tabla temporal--->
			<cfquery datasource="sifinterfacessybase">
				insert into PS_PMI_GL_DET_NOM_2(PMI_GL_COD_EJEC,
							PMI_GL_LINEA,
				 			PMI_GL_RUBRO,
							PMI_GL_SUBRUBRO,
							PMI_GL_EMPLEADO,
							PMI_GL_DESCRIPCION,
							PMI_GL_TIPO,
							PMI_GL_IMPORTE,
							PMI_GL_CTRO_COSTOS,
							PMI_GL_CUENTA) 
					values ('#rsDNominas.PMI_GL_COD_EJEC#',
							#rsDNominas.PMI_GL_LINEA#,
				 			<cfif isdefined("rsDNominas.PMI_GL_RUBRO") and rsDNominas.PMI_GL_RUBRO GT 0>
								#rsDNominas.PMI_GL_RUBRO#,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined("rsDNominas.PMI_GL_SUBRUBRO") and rsDNominas.PMI_GL_SUBRUBRO GT 0>
								#rsDNominas.PMI_GL_SUBRUBRO#,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined("rsDNominas.PMI_GL_EMPLEADO") and rsDNominas.PMI_GL_EMPLEADO GT 0>
								#rsDNominas.PMI_GL_EMPLEADO#,
							<cfelse>
								null,
							</cfif>
							'#rsDNominas.PMI_GL_DESCRIPCION#',
							'#rsDNominas.PMI_GL_TIPO#',
							<cfif isdefined("rsDNominas.PMI_GL_IMPORTE") and rsDNominas.PMI_GL_IMPORTE GT 0>
								#rsDNominas.PMI_GL_IMPORTE#,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined("rsDNominas.PMI_GL_CTRO_COSTOS") and rsDNominas.PMI_GL_CTRO_COSTOS GT 0>
								#rsDNominas.PMI_GL_CTRO_COSTOS#,
							<cfelse>
								null,
							</cfif>		
							'#rsDNominas.PMI_GL_CUENTA#')										
			</cfquery>
		</cfloop>
		</cfif>
	</cfloop>
</cfif>
		
<cfset Session.varNavegacion = "#rsNominas.PMI_GL_COD_EJEC#">

</cfoutput> 

<!---<cfoutput>
 <table>
    <tr>
		<tr> 
		<td width="50">&nbsp;</td>
            <td width="100000"><strong><br>Nominas pendientes: </br><strong/></td> </td> 
            <td colspan="2">
			</tr>
	    	<td align="justify" colspan="4"  width="600" height="30">
            	</tr></tr>
            </td>					
		<!---	 <tr>
        	<td align="left" colspan="4">
            	<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
                <label for="chkTodos">Seleccionar Todos</label>
            </td>
			</tr>--->
        </tr>
		   
       <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsNominas#"/>
			<cfinvokeargument name="cortes" value="PMI_GL_COD_EJEC"/>
			<cfinvokeargument name="desplegar" value="PMI_GL_COD_EJEC, PMI_GL_DESCRIPCION, PMI_GL_FECHA_EMISI, PMI_GL_COD_EJEC_REF, Cancelacion"/>
			<cfinvokeargument name="etiquetas" value="Nómina, Descripción, Fecha, Nómina Referencia, Cancelación"/>
			<cfinvokeargument name="formatos" value="S,S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N"/>
			<cfinvokeargument name="align" value="left, left, left, left,left"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="irA" value="interfaz925PMI-Consulta.cfm"/>   
            <cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="PMI_GL_COD_EJEC"/>
			<cfinvokeargument name="botones" value="Aplicar,Regresar"/>
            <cfinvokeargument name="navegacion" value=""/>
         </cfinvoke>
</table>

<cfset session.ListaReg = #rsNominas#>
<script type="text/javascript">
function algunoMarcado(){
		var aplica = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				aplica = document.lista.chk.checked;
			}else{
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("¿Aplicar Registros seleccionados?"));
		} else {
			return false;
		}
	}

function funcAplicar() {
		if (algunoMarcado())
			document.lista.action = "interfaz925PMI-Motor.cfm";
		else
			return false;
	}
	
function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.lista.chk.length; counter++)
			{				if ((!document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.lista.chk.length; counter++)
			{
				if ((document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = false;
			}
		};
	}
	
function funcRegresar() {
			document.lista.action = "Interfaz925PMI-Param.cfm";		
		}
</script>
</cfoutput> --->



