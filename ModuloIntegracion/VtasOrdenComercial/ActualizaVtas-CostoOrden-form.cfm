<!--- 
	Creado por Angeles Blanco
		Fecha: 23 Septiembre 2010
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Movimientos adicionales de Utilidad Bruta'>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfquery name="rsPeriodo" datasource="sifinterfaces">
	select distinct(E.Periodo) as Periodo from ESIFLD_HFacturas_Venta E
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by E.Periodo desc
</cfquery>

<cfquery name="rsMes" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 	
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfquery name="rsMoneda" datasource="#session.dsn#">
	select Miso4217, Mnombre from Monedas where Ecodigo = 8 
	order by Miso4217 desc
</cfquery>

<cfquery name="rsAñoMes" datasource="#session.dsn#">
select convert(integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=   "#Session.Ecodigo#"> and Pcodigo = 60)) as Mes,
case convert (integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=     "#Session.Ecodigo#"> and Pcodigo = 60)) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when    10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as NomMes,
(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    "#Session.Ecodigo#"> and Pcodigo = 50) as Año
</cfquery>

<cfquery name="rsProducto" datasource="#session.dsn#">
	select ODchar as Producto, ODcomplemento+'-'+ODchar as Clave from OrigenDatos where OPtabla = 'PMI_Cmdty_Padre' and 	    Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	group by ODchar, ODcomplemento 
	order by ODcomplemento 
</cfquery>


<!---INICIA FORM--->
<cfoutput>
	<form name="form1" method="post" action="ActualizaVtas-CostoOrden-sql.cfm">
	<fieldset>
	<table width="99%" cellpadding="2" cellspacing="0" border="0" align="center">
			<tr>
			<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td width="130">*<strong>&nbsp;Periodo: </strong></td>
            	<td width="50">		
					<select name="fltPeriodo" tabindex="5">
						<cfloop query="rsPeriodo">
                    		<option value="#rsPeriodo.Periodo#" <cfif #rsAñoMes.Año# EQ "#rsPeriodo.Periodo#">selected</cfif>>#rsPeriodo.Periodo#</option>
               			</cfloop>
					</select>
				</td>
				<td colspan="1">&nbsp;</td>
				<td width="140">*<strong>&nbsp;Mes: </strong></td>
					<td>
					  <select name="fltMes" tabindex="5"> 
		              		<cfloop query="rsMes">
                    		<option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>      
               				</cfloop>
                		</select> 
					</td>
			</tr>
			<tr>
			<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>	
			<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="140">*<strong>&nbsp;Movimiento: </strong></td>
            	<td width="50">		
					<select name="fltNaturaleza" tabindex="7"> 
		                <option value="-1" selected="selected">-------------</option>
						<option value="P">DEBITO</option>
						<option value="N">CREDITO</option>
                	</select>
           		</td>	
				<td colspan="1">&nbsp;</td>
				<td width="130">*<strong>&nbsp;Moneda: </strong></td>
            	<td width="50">	
					<select name="fltMoneda" tabindex="5">
						<option value="-1" selected="selected">------------------</option>	
						<cfloop query="rsMoneda">
                    		<option value="#rsMoneda.Miso4217#" <cfif isdefined("form.fltMoneda") and trim(form.fltMoneda) EQ trim(rsMoneda.Miso4217)>selected</cfif>>#rsMoneda.Mnombre#</option>
               			</cfloop>
					</select>
				</td>										
    		</tr>
			<tr>
			<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td width="150">*<strong>&nbsp;Tipo Documento: </strong></td>
					<td>
						<select name="fltTipoDoc" tabindex="7"> 
		                <option value="-1" selected="selected">-----------</option>
						<option value="PRFC">FACT</option>
						<option value="PRNF">NOFACT</option>
                		</select>
            		</td>
				<td colspan="1">&nbsp;</td>
				<td width="140">*<strong>&nbsp;Operación: </strong></td>
					<td>
						<select name="fltOperacion" tabindex="7"> 
		                <option value="-1" selected="selected">-----------</option>
						<option value="I">INGRESO</option>
						<option value="C">COSTO</option>
                		</select>
            		</td>
			</tr>
			<tr>
			<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
			<td colspan="1">&nbsp;</td>
				<td width="150">*<strong>&nbsp;&nbsp;Importe: </strong>
					<td> <input type="text" name="Importe" size="20" />
				</td>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="170">*<strong>&nbsp;&nbsp;Poliza(s) Origen: </strong>
					<td> <input type="text" name="Poliza" size="30" /></td>
				</td>	
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td width="130">*<strong>&nbsp;Orden Comercial: </strong></td>
          		<td width="30">
<!---				<cfset ArrayTrREF=ArrayNew(1)>
			 	 <cfquery name="rsOrden" datasource="sifinterfaces">
				 	 select '' as Orden 
					 union
				 	 select distinct(isnull(E.Contrato,V.Venta)) as Orden from ESIFLD_HFacturas_Venta E
					 inner join SIFLD_HCosto_Venta V on V.Venta = E.Contrato
					 inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
					 where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
					 value="#Session.Ecodigo#"> and E.Clas_Venta in ('PRFC','PRNF')
					 order by Orden asc
				 </cfquery>
				 --->
				<cfif not isdefined("form.Nuevo")>
					<input type="hidden" name="Orden" value="<cfif isdefined("Form.Contrato")>#Form.Contrato#</cfif>"> 
				
					<cfif isdefined("Form.Contrato")>
	                     <cfset varvalue = Form.Contrato>
    	                 <cfset Form.Orden = Form.Contrato>
        	        <cfelse>
            	         <cfset varvalue = "">
                	 </cfif>
				
				<!---<cfset ArrayAppend(ArrayTrREF,rsOrden.Orden)>--->
				<cf_conlis
				Campos="Contrato"
				Desplegables="S"
				Modificables="S"
				Size="15"
				tabindex="6"
				ValuesArray="#varvalue#" 
				Title="Lista de Ordenes Comerciales"
				Tabla="#sifinterfacesdb#..ESIFLD_HFacturas_Venta E inner join #sifinterfacesdb#..SIFLD_HCosto_Venta V on V.Venta = E.Contrato inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo)"
				Columnas="distinct(Contrato)"<!---CAmpos que se ven en la lista--->
				Filtro="I.Ecodigo = #Session.Ecodigo# and E.Periodo is not null" 
				Desplegar="Contrato"
				Etiquetas="Orden Comercial"
				filtrar_por="Contrato"
				Formatos="S"
				Align="left"
				form="form1"
				Asignar="Contrato" <!----Valores que se muestran en la pantalla----->
				Asignarformatos="S"
				showEmptyListMsg="true"
                permiteNuevo="true"/>
				<cfelse>
					<input type="text" name="Orden" size="15" maxlength="30" value="<cfif isdefined("Form.Orden")>#Form.Orden#</cfif>">
				</cfif>											
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td><strong>&nbsp;&nbsp;Observaciones: </strong>
			  <td> <input type="text" name="Observaciones" size="55" width="100"  /></td>
				</td>
    		</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td>* Campos Obligatorios</td>
    		</tr>
    	
            <tr><td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr><td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			
            <tr>
            <table width="99%" border="0" align="center">
            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td align="left"><cf_botones values="Guardar" names="Guardar"></td>
			<td align="left"><cf_botones values="Limpiar" names="Limpiar"></td>
   			<td align="rigth"><input type="button" style="BORDER: rgb(128,128,128) 1px outset;  BACKGROUND-COLOR: white" tabindex="100" name="Importar" value="Importar" onClick="javascript: location.href = '/cfmx/ModuloIntegracion/VtasOrdenComercial/ImportaMoviAdicionalUtilBruta.cfm'; " ></td>
			<td align="rigth"><input type="button" style="BORDER: rgb(128,128,128) 1px outset;  BACKGROUND-COLOR: white" name="MovimientosImportados" value="Movimientos Importados" onClick="javascript: location.href='/cfmx/ModuloIntegracion/VtasOrdenComercial/FormActualizaVtas-CostoOrden.cfm'"></td>
			</table>	
   		</tr>
        	
		
			
			
	</table>
	</fieldset>
	</form>
    <!---TERMINA FORM--->
	
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	function funcGuardar()
		{
			var mensaje = '';
			if (document.form1.fltPeriodo.value == '-1'){
				mensaje += '- Periodo\n';
			}
			if (document.form1.fltMes.value == '-1'){
				mensaje += '- Mes\n';
			}
			if (document.form1.fltMoneda.value == '-1'){
				mensaje += '- Moneda\n';
			}
			if (document.form1.fltTipoDoc.value == '-1'){
				mensaje += '- Tipo de Documento\n';
			}
			if (document.form1.fltNaturaleza.value == '-1'){
				mensaje += '- Movimiento\n';
			}
			if (document.form1.fltOperacion.value == '-1'){
				mensaje += '- Operacion\n';
			}
			if (document.form1.Importe.value == ''){
				mensaje += '- Importe\n';
			}
			if(document.form1.Contrato.value == ''){
				mensaje += '- Orden Comercial\n';
			}
			if(document.form1.Poliza.value == ''){
				mensaje += '- Poliza(s) Origen';
			}
			if (mensaje != ''){
				alert('Los siguientes campos son requeridos:\n\n' + mensaje)
				return false;
			}
			else
			{
			return true;
			}
		}
		
		
	function funcLimpiar()
	{
			document.form1.fltNaturaleza.value = '-1';
			document.form1.fltMoneda.value = '-1';
			document.form1.fltOperacion.value = '-1';
			document.form1.fltNaturaleza.value = '-1';
			document.form1.Contrato.value = '';
			document.form1.OC.value = '';
			document.form1.Importe.value = '';
			document.form1.Observaciones.value = '';
			document.form1.Poliza.value = '';
	}
	
</script>


