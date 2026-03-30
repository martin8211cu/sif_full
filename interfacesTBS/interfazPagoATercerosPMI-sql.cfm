<!--- JMRV. Inicio. Pagos a terceros. 31/07/2014 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generación de Pagos'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="8600">
<cfset varNavegacion = ''>
<cfif isdefined("url.PageNum_lista") and len(trim(url.PageNum_lista)) GT 0>
	<cfset varNavegacion = varNavegacion & "&pagina=#url.PageNum_lista#">
<cfelse>
	<cfset varNavegacion = varNavegacion & "&pagina=1">
</cfif>
<cfsetting enablecfoutputonly="yes">

<cfoutput>
	
<!--- Ahora los datos serán insertados  directamente en la tabla

	<!--- Trae los datos de la base de datos externa --->
	<cfquery name="rsPagos" datasource="peoplesoft">
			select 
				ltrim(rtrim(PMI_COD_PAGO)) as PMI_COD_PAGO, 
				PMI_OBSERVACIONES, 
				PMI_FECHA_EMISI,
				case when (convert (int, PMI_RUBRO)) = 0 then null else (convert (int, PMI_RUBRO)) end as PMI_RUBRO,
				case when convert(int, PMI_SUBRUBRO) = 0 then null else convert(int, PMI_SUBRUBRO) end as PMI_SUBRUBRO,
				case when convert(int, PMI_BENEFICIARIO) = 0 then null else convert(int, PMI_BENEFICIARIO) end as PMI_BENEFICIARIO, 
				PMI_DESCRIPCION,    
				PMI_IMPORTE,
				case when (convert (int, PMI_CTRO_COSTOS)) = 0 then null else (convert (int,PMI_CTRO_COSTOS)) end as PMI_CTRO_COSTOS,
				PMI_CUENTA,
				case when convert(int, PMI_SNEGOCIOS) = 0 then null else convert(int, PMI_SNEGOCIOS) end as PMI_SNEGOCIOS
				
			from PS_PMI_INTFZ_PGTR
	</cfquery>

	<!--- Si se trajeron datos desde la interfaz externa --->
	<cfif rsPagos.recordcount GT 0>
	
		<cfquery datasource="sifinterfaces">
			delete PS_PMI_INTFZ_PGTR
		</cfquery>
	
		<cfloop query="rsPagos">
		
			<!---Inserta los datos provenientes de la interfaz externa en una tabla temporal--->
			<cfquery datasource="sifinterfaces">
				insert into PS_PMI_INTFZ_PGTR( 
								PMI_COD_PAGO, 
								PMI_OBSERVACIONES, 
								PMI_FECHA_EMISI,
								PMI_RUBRO,
								PMI_SUBRUBRO,
								PMI_BENEFICIARIO,
								PMI_DESCRIPCION,
								PMI_IMPORTE,
								PMI_CTRO_COSTOS,
								PMI_CUENTA,
								PMI_SNEGOCIOS)
								
					values ('#rsPagos.PMI_COD_PAGO#',
							'#rsPagos.PMI_OBSERVACIONES#',
							'#rsPagos.PMI_FECHA_EMISI#',
							<cfif rsPagos.PMI_RUBRO neq "">
							 #rsPagos.PMI_RUBRO#,
							<cfelse>
							 null,
							</cfif>
							<cfif rsPagos.PMI_RUBRO neq "">
							 #rsPagos.PMI_SUBRUBRO#,
							<cfelse>
							 null,
							</cfif>
							'#rsPagos.PMI_BENEFICIARIO#',
							'#rsPagos.PMI_DESCRIPCION#',
							 #rsPagos.PMI_IMPORTE#,
							 #rsPagos.PMI_CTRO_COSTOS#,
							'#rsPagos.PMI_CUENTA#',
							'#rsPagos.PMI_SNEGOCIOS#')
			</cfquery>
	
		</cfloop><!--- rsPagos --->
	</cfif><!--- rsPagos.recordcount GT 0 --->

	Ahora los datos serán insertados  directamente en la tabla --->
	
	<!---Datos a mostrar en el plista--->
	<cfquery name="rsPagos" datasource="sifinterfaces">
			select 
				ltrim(rtrim(PMI_COD_PAGO)) as PMI_COD_PAGO, 
				PMI_OBSERVACIONES,
				PMI_FECHA_EMISI,
				PMI_LINEA,
				case when (convert (int, PMI_RUBRO)) = 0 then null else (convert (int, PMI_RUBRO)) end as PMI_RUBRO,
				case when convert(int, PMI_SUBRUBRO) = 0 then null else convert(int, PMI_SUBRUBRO) end as PMI_SUBRUBRO,
				PMI_BENEFICIARIO, <!--- JMRV 13/01/2015 --->
				PMI_DESCRIPCION,    
				PMI_IMPORTE,
				case when (convert (int, PMI_CTRO_COSTOS)) = 0 then null else (convert (int,PMI_CTRO_COSTOS)) end as PMI_CTRO_COSTOS,
				PMI_CUENTA,
				case when convert(int, PMI_SNEGOCIOS) = 0 then null else convert(int, PMI_SNEGOCIOS) end as PMI_SNEGOCIOS
				
			from PS_PMI_INTFZ_PGTR
	</cfquery>
		
	<cfset Session.varNavegacion = "#rsPagos.PMI_COD_PAGO#">
</cfoutput> 

<cfoutput>
 <table>
    <tr>
		<tr> 
		<td width="50">&nbsp;</td>
            <td width="100000"><strong><br>Pagos pendientes: </br><strong/></td> </td> 
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
			<cfinvokeargument name="query" value="#rsPagos#"/>
			<cfinvokeargument name="desplegar" value="PMI_COD_PAGO, PMI_OBSERVACIONES, PMI_FECHA_EMISI"/>
			<cfinvokeargument name="etiquetas" value="Pago, Observaciones, Fecha"/>
			<cfinvokeargument name="formatos" value="S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N"/>
			<cfinvokeargument name="align" value="left, left, left"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="irA" value="interfazPagoATercerosPMI-Consulta.cfm"/> 
            <cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="PMI_COD_PAGO,PMI_LINEA"/>
			<cfinvokeargument name="botones" value="Aplicar,Regresar,Eliminar"/>
            <cfinvokeargument name="navegacion" value="PMI_COD_PAGO&PMI_LINEA"/>
         </cfinvoke>
</table>

<cfset session.ListaReg = #rsPagos#>
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

	function algunoMarcado2(){
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
			return (confirm("¿Eliminar Registros seleccionados?"));
		} else {
			return false;
		}
	}

function funcAplicar() {
		if (algunoMarcado())
			document.lista.action = "interfazPagoATercerosPMI-Motor.cfm";
		else
			return false;
	}

function funcEliminar() {
		if (algunoMarcado2())
			document.lista.action = "interfazPagoATercerosPMI-Consulta.cfm";
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
			document.lista.action = "InterfazPagoATercerosPMI-Param.cfm";		
		}
</script>
</cfoutput> 

<!--- JMRV. Fin. Pagos a terceros. 31/07/2014 --->



