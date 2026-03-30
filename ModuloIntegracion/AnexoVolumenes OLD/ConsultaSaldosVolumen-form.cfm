<!--- 
	Creado por Angeles Blanco
		Fecha: 16 marzo 2010
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Volúmenes de Ventas'>
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">
<cf_navegacion name="fltTipoVenta" 		navegacion="" session default="-1">
<cf_navegacion name="fltProducto" 		navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 		navegacion="" session default="-1">
<cf_navegacion name="Grupo1" 		navegacion="" session default="-1">
<cf_navegacion name="MovAd" 		navegacion="" session default="-1">

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

<cfquery name="rsProducto" datasource="#session.dsn#">
	select ODchar as Producto, ODcomplemento+'-'+ODchar as Clave from OrigenDatos where OPtabla = 'PMI_Cmdty_Padre' and 	    Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	group by ODchar, ODcomplemento 
	order by ODcomplemento 
</cfquery>

<cfquery name="rsEquiv" datasource="#Session.DSN#">
	select EQUcodigoOrigen, EQUcodigoSIF, EQUdescripcion, EQUidSIF 
    from #sifinterfacesdb#..SIFLD_Equivalencia
    where SIScodigo = 'ICTS'
    and CATcodigo = 'SOCIO_ANEX'
	and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif rsEquiv.recordcount GT 1>
<cfset Ecodigo = ''>
<cfloop query="rsEquiv">
	<cfif Ecodigo EQ "">
		<cfset Ecodigo = rsEquiv.EQUidSIF>
	<cfelse>
		<cfset Ecodigo = Ecodigo & ', ' & rsEquiv.EQUidSIF>
	</cfif>		
</cfloop>
</cfif>

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

<cfoutput>
<cfset LvarNavegacion = ""> 

<cfif Form.fltPeriodo NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodo=#Form.fltPeriodo#">
</cfif>

<cfif Form.fltMes NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMes=#Form.fltMes#">
</cfif>

<cfif Form.fltTipoVenta NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltTipoVenta=#Form.fltTipoVenta#">
</cfif>

<cfif Form.fltProducto NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltProducto=#Form.fltProducto#">
</cfif>

<cfif Form.fltTipoDoc NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltTipoDoc=#Form.fltTipoDoc#">
</cfif>

	<form name="form1" method="post" action="">
	<table width="100%">
				<tr>
				<td></td>
				<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
				<tr>
				<td width="150"><strong>Periodo:</strong>
					<select name="fltPeriodo" tabindex="3">
					<option value="-1" selected="">(Todos)</option>
						<cfloop query="rsPeriodo">
                    		<option value="#rsPeriodo.Periodo#" <cfif #rsAñoMes.Año# EQ "#rsPeriodo.Periodo#">selected</cfif>>#rsPeriodo.Periodo#</option>
               			</cfloop>
					</select>
				</td>
				<td colspan="1">&nbsp;&nbsp;</td>
				<td width="150"><strong>Mes: </strong>
						<select name="fltMes" tabindex="5">
						<option value="-1" selected="">(Todos)</option> 
		              		<cfloop query="rsMes">
                    		<option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>      
               				</cfloop>
                		</select>
            	</td>
				<td width="280"><strong>&nbsp;&nbsp;&nbsp;&nbsp;Tipo de Venta: </strong>	
					<select name="fltTipoVenta" tabindex="7"> 
		                <option value="-1" selected="selected">(Todos)</option>
						<option value="EXP"label="EXPORTACION"></option>
						<option value="IMP" label="IMPORTACION"></option>
						<option value="TER" label="TERCEROS"></option>
						<option value="VTA" label="ALMACEN"></option>
						<option value="VTM" label="MIXTAS"></option>
						<option value="VTN" label="TERRITORIO NACIONAL"></option>
						<option value="VAE" label="ALIANZA ESTRATEGICA"></option>
                	</select>	
				</td>
					<td width="240"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tipo Documento: </strong>
						<select name="fltTipoDoc" tabindex="5"> 
		                <option value="-1" selected="selected">(Todos)</option>
						<option value="PRFC" label="FACT"></option>
						<option value="PRNF" label="NOFACT"></option>
                		</select>
            	</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td width="220"><strong>Producto: </strong>
					<select name="fltProducto" tabindex="7"> 
		         		<option value="-1" selected="selected">(Todos)</option>
               				<cfloop query="rsProducto">
                    		<option value="#rsProducto.Producto#" <cfif isdefined("form.fltProducto") and trim(form.fltProducto) EQ trim(rsProducto.Producto)>selected</cfif>>#rsProducto.Clave#</option>
               				</cfloop>
                	</select>	
            	</td>
				<td colspan="1">&nbsp;&nbsp;</td>
				<td width="220">
					<input  type="checkbox" name="chkMovAd"  id="chkMovAd"
					<cfif isdefined("Form.chkMoAd") and Form.chkMovAd EQ 1>checked</cfif>
					onclick="if (this.checked){}" value="1"><strong>Solo Movimientos Adicionales</strong>
				</td>
				<td colspan="3" width="550"><strong>&nbsp;&nbsp;&nbsp;&nbsp;Empresa: </strong>
            			<input  type="radio" name="Grupo1" value="Nasa"/>
						NASA
						<input type="radio" name="Grupo1" value="Intercompañia"/>
						Interempresa
						<input type="radio" name="Grupo1" value="Ninguno"  checked="checked"/>
						#rsEmp.Edescripcion#
						</td>
				</td>		
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td>
			</tr>
		
			<tr></tr>
					<table width="50" align="center">
			   		<tr><td><cf_botones values="Seleccionar" names="Seleccionar"></td>
					<td><cf_botones values="Limpiar" names="Limpiar"></td>
					<td><cf_botones values="Consultar" names="Consultar"></td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>		
			<td colspan="8">
                <cfquery name="rsLista" datasource="#Session.DSN#">
                    select ID_Saldo, Periodo, case Mes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 			                    4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when                    9 then 'Septiembre' when    10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as                    Mes, Clas_Venta + Producto as Clave, case Tipo_Documento when 'PRFC' then 				                    'FACT' when 'PRNF' then 'NOFACT' end as Tipo_Documento,	convert(varchar, convert(money,                     sum(Volumen_Documento)),1) as Volumen_Documento, convert(varchar,convert(money,sum(Volumen_Actual)),1)                    as Volumen_Actual
					from SaldosVolumen 
					where 
					1=1
					<cfif form.Grupo1 EQ 'Ninguno' or form.Grupo1 EQ 'Nasa'>
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					<cfelseif form.Grupo1 EQ 'Intercompañia'>
						<cfif rsEquiv.recordcount EQ 1>
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">
						<cfelseif rsEquiv.recordcount GT 1>
							and Ecodigo in (#Ecodigo#)
						</cfif>
					</cfif>
					<cfif form.fltPeriodo neq "-1">
						and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> 
					</cfif>
					<cfif form.fltMes neq "-1">
						and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
					</cfif>
					<cfif form.fltTipoVenta neq "-1" and form.Grupo1 EQ 'Ninguno'>
       					and  Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltTipoVenta)#">
					<cfelseif form.fltTipoVenta neq "-1" and form.Grupo1 EQ 'Nasa'>
						and Clas_Venta in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltTipoVenta)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">)
					<cfelseif form.fltTipoVenta eq "-1" and form.Grupo1 EQ 'Nasa'>
						and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">						
				    </cfif>
					<cfif form.fltProducto neq "-1">
				       	and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltProducto)#">
					</cfif>
					<cfif form.fltTipoDoc neq "-1">
				       	and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltTipoDoc)#">
				    </cfif>
					<cfif isdefined("form.chkMovAd") and form.chkMovAd EQ 1>
						and Volumen_Actual != Volumen_Documento
					</cfif>
					group by Periodo, Mes, Tipo_Documento, Producto, Ecodigo, Clas_Venta
					order by Periodo, Mes, Producto
				</cfquery>
			</td>
    	
			</table>
		</table>
	</form>

	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value="Clave"/>
			<cfinvokeargument name="desplegar"value="ID_Saldo,Periodo,Mes,Tipo_Documento,Volumen_Documento, Volumen_Actual"/>
			<cfinvokeargument name="etiquetas"value="Registro,Periodo,Mes,Tipo Documento,Volumen Documento, Volumen Actual"/>
			<cfinvokeargument name="formatos" value="S,S,V,S,S,S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,S,N"/>
			<cfinvokeargument name="align" value="center,center, center, center, left,left"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="ConsultaSaldosVolumen-registro.cfm"/>   
            <cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="ID_Saldo"/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
		</cfinvoke>

</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>


<script language="javascript" type="text/javascript">
	function funcLimpiar()
		{
			document.form1.fltPeriodo.value = '-1';
			document.form1.fltMes.value = '-1';
			document.form1.fltTipoVenta.value = '-1';
			document.form1.fltTipoDoc.value = '-1';
			document.form1.Grupo1.value = 'Ninguno';
		}
	function funcConsultar()
	{
		document.form1.action = "ConsultaSaldosVolumen-exportacion.cfm";
	}
</script>


