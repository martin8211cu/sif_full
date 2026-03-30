<!--- 
	Creado por Angeles Blanco
		Fecha: 12 Agosto 2010
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Movimientos adicionales de Volúmenes de Ventas'>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfquery name="rsPeriodo" datasource="sifinterfaces">
	select distinct(E.Periodo) as Periodo from ESIFLD_Facturas_Venta E
	inner join DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
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

<!---<cfquery name="rsTipoVenta" datasource="sifinterfaces">
	select distinct(D.Clas_Venta_Lin) from ESIFLD_Facturas_Venta E
	inner join DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	where D.Clas_Venta_Lin is not null and D.Clas_Venta_Lin not in (' ') 
	order by Clas_Venta_Lin 
</cfquery>--->

<cfquery name="rsAñoMes" datasource="#session.dsn#">
select convert(integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=   "#Session.Ecodigo#"> and Pcodigo = 60)) - 1  as Mes,
case convert (integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=     "#Session.Ecodigo#"> and Pcodigo = 60)) - 1 when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when    10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as NomMes,
(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    "#Session.Ecodigo#"> and Pcodigo = 50) as Año
</cfquery>

<cfquery name="rsEmp" datasource="#session.dsn#">
	select E.Edescripcion from #sifinterfacesdb#..int_ICTS_SOIN I
	inner join Empresas E on I.Ecodigo = E.Ecodigo where E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
	value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsProducto" datasource="#session.dsn#">
	select ODchar as Producto, ODcomplemento+'-'+ODchar as Clave from OrigenDatos where OPtabla = 'PMI_Cmdty_Padre' and 	    Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	group by ODchar, ODcomplemento 
	order by ODcomplemento 
</cfquery>

<cfoutput>
	<form name="form1" method="post" action="ActualizaSaldosVolumen-sql.cfm">
	<fieldset>
	<table width="99%" cellpadding="2" cellspacing="0" border="0" align="center">
			<tr>
			<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1"></td>
					<td><strong>&nbsp;&nbsp;Empresa: </strong>
            			<td><input  type="radio" name="Grupo1" value="Nasa"/>
						NASA
						</td>
					</td>
			<tr>
			
			<tr>
				<td colspan="1"></td>
					<td><strong></strong>
						<td><input type="radio" name="Grupo1" value="Intercompañia"/>
						Interempresa
						</td>
					</td>
				</td>
			<tr>
				<td colspan="1"></td>
					<td><strong></strong>
						<td><input type="radio" name="Grupo1" value="Ninguno" checked="checked"/>
						#rsEmp.Edescripcion#
						</td>
					</td>
				</td>
				
           	</tr>                       
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
            		  <td>
					  <select name="fltMes" tabindex="5"> 
		              		<cfloop query="rsMes">
                    		<option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>      
               				</cfloop>
                		</select> </td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="130">*<strong>&nbsp;Tipo de Venta: </strong></td>
            	<td width="50">	
					<select name="fltTipoVenta" tabindex="7"> 
		                <option value="-1" selected="selected">---------------------</option>
						<option value="EXP"label="EXPORTACION"></option>
						<option value="IMP" label="IMPORTACION"></option>
						<option value="TER" label="TERCEROS"></option>
						<option value="VTA" label="ALMACEN"></option>
						<option value="VTM" label="MIXTAS"></option>
						<option value="VTN" label="TERRITORIO NACIONAL"></option>
						<option value="VAE" label="ALIANZA ESTRATEGICA"></option>
                	</select>	
					<!---<select name="fltTipoVenta" tabindex="5"> 
		         	<option value="-1" selected="selected">------</option>
               				<cfloop query="rsTipoVenta">
                    		<option value="#rsTipoVenta.Clas_Venta_Lin#" <cfif isdefined("form.fltTipoVenta") and trim(form.fltTipoVenta) EQ trim(rsTipoVenta.Clas_Venta_Lin)>selected</cfif>>#rsTipoVenta.Clas_Venta_Lin#</option>
               				</cfloop>
                	</select>--->
            	</td>
				<td colspan="1">&nbsp;</td>
				<td width="140">*<strong>&nbsp;Tipo Documento: </strong></td>
					<td>		
            		<td>
						<select name="fltTipoDoc" tabindex="7"> 
		                <option value="-1" selected="selected">-----------</option>
						<option value="PRFC" label="FACT"></option>
						<option value="PRNF" label="NOFACT"></option>
                		</select>
            	</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="130">*<strong>&nbsp;Movimiento: </strong></td>
            	<td width="50">		
					<select name="fltNaturaleza" tabindex="7"> 
		                <option value="-1" selected="selected">-------------------------</option>
						<option value="P" label="DEBITO"></option>
						<option value="N" label="CREDITO"></option>
                	</select>
            	</td>
					<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="150">*<strong>&nbsp;Producto: </strong></td>
            	<td>
				<td>		
					<select name="Ccodigo" tabindex="7"> 
		         		<option value="-1" selected="selected">----------------------</option>
               				<cfloop query="rsProducto">
                    		<option value="#rsProducto.Producto#" <cfif isdefined("form.Ccodigo") and trim(form.Ccodigo) EQ trim(rsProducto.Producto)>selected</cfif>>#rsProducto.Clave#</option>
               				</cfloop>
                	</select>	
            	</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<!---<tr>
				<td colspan="1">&nbsp;</td>
				<td width="130">*<strong>&nbsp;Producto: </strong></td>
          		<td width="50">		
				<cfset ArrayTrREF=ArrayNew(1)>
			 	 <cfquery name="rsProductos" datasource="#session.dsn#">
					 select null as Cid, '' as Ccodigo, '' as Cdescripcion
 					 union
					 select Cid, Ccodigo, Cdescripcion 
					 from Conceptos 
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	                 order by Cid 
				</cfquery>
				
				<cfset ArrayAppend(ArrayTrREF,rsProductos.Ccodigo)>
				<cfset ArrayAppend(ArrayTrREF,rsProductos.Cdescripcion)>
				<!---<cf_conlis
				Campos="Ccodigo, Cdescripcion"
				Desplegables="S,S"
				Modificables="S,N"
				Size="10,43"
				tabindex="6"
				ValuesArray="#ArrayTrREF#" 
				Title="Lista de Productos"
				Tabla="Conceptos"
				Columnas="Ccodigo, Cdescripcion" ---><!---CAmpos que se ven en la lista--->
				Filtro="Ecodigo = #Session.Ecodigo#" 
				Desplegar="Ccodigo, Cdescripcion"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="Ccodigo, Cdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="Ccodigo, Cdescripcion" <!----Valores que se muestran en la pantalla----->
				Asignarformatos="S,S"/>			
			</td>
    	</tr>--->
			<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="170">*<strong>&nbsp;&nbsp;Poliza(s) Origen: </strong>
					<td> <input type="text" name="Poliza" size="30" /></td>
				</td>
				<td colspan="1">&nbsp;</td>
					<td width="160">*<strong>&nbsp;Volumen en Barriles: </strong></td>
					<td>	
					<td> <input type="text" name="Volumen" size="12" /></td>
				</td>
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
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td>
		</tr>
		</tr>
		<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td>* Campos Obligatorios</td>
    	</tr>
			<tr align="center"><td width="50" align="center" colspan="2">&nbsp;</td>
			<td><cf_botones values="Guardar" names="Guardar"><td>
			<cf_botones values="Limpiar" names="Limpiar"></td></td>	
			<tr>
				<td colspan="1">&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;</td>
		
				<!---<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr> 
			  <td colspan="7"> 
				<div align="center"> 
				  <input type="submit" name="Guardar" value="Guardar" tabindex="16">&nbsp;
				  <input type="Reset" name="Limpiar" value="Limpiar" tabindex="17">
				</div>
			  </td>
			</tr>
			<tr>--->
			
	</table>
	</fieldset>
	</form>
	
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
			if (document.form1.fltTipoVenta.value == '-1'){
				mensaje += '- Tipo de Venta\n';
			}
			if (document.form1.fltTipoDoc.value == '-1'){
				mensaje += '- Tipo de Documento\n';
			}
			if (document.form1.fltNaturaleza.value == '-1'){
				mensaje += '- Naturaleza\n';
			}
			if (document.form1.Volumen.value == ''){
				mensaje += '- Volumen\n';
			}
			if(document.form1.Ccodigo.value == ''){
				mensaje += '- Producto';
			}
			if(document.form1.Poliza.value == ''){
				mensaje += '- Poliza(s) Origen';
			}
			if (mensaje != ''){
				alert('Los siguientes campos son requeridos:\n\n' + mensaje)
				return false;}
			else{
			return true;
			}
		}
		
	function funcLimpiar()
		{
			document.form1.fltPeriodo.value = rsAñoMes.Año;
			document.form1.fltMes.value = rsAñoMes.Mes;
			document.form1.fltTipoVenta.value = '-1';
			document.form1.fltTipoDoc.value = '-1';
			document.form1.fltNaturaleza.value = '-1';
			document.form1.Volumen.value = '';
			document.form1.Ccodigo.value = '';
			document.form1.Grupo1.value = 'Ninguno';
			document.form1.Observaciones.value = '';
			document.form1.Poliza.value = '';
		}
</script>


