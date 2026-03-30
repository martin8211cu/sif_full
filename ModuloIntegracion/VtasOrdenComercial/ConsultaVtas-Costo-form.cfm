<!--- 
	Creado por Angeles Blanco
		Fecha: 16 marzo 2010
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Utilidad Bruta por Orden Comercial'>
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cf_navegacion name="fltPeriodoIni" 		navegacion="" session default="-1">
<cf_navegacion name="fltPeriodoFin" 		navegacion="" session default="-1">
<cf_navegacion name="fltMesIni" 		    navegacion="" session default="-1">
<cf_navegacion name="fltMesFin" 		    navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 			navegacion="" session default="-1">
<cf_navegacion name="fltOperacion" 			navegacion="" session default="-1">
<cf_navegacion name="fltNaturaleza" 		navegacion="" session default="-1">
<cf_navegacion name="fltMoneda"  	    	navegacion="" session default="-1">
<cf_navegacion name="Contrato"  	    	navegacion="" session default=" ">

<cfquery name="rsPeriodo" datasource="sifinterfaces">
	select distinct(E.Periodo) as Periodo from ESIFLD_HFacturas_Venta E
	inner join DSIFLD_HFacturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
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
select convert(integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
value="#Session.Ecodigo#"> and Pcodigo = 60)) as Mes,
case convert (integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
value= "#Session.Ecodigo#"> and Pcodigo = 60)) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when    10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as NomMes,
    (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
	value= "#Session.Ecodigo#"> and Pcodigo = 50) as Año
</cfquery>

<cfquery name="rsEmp" datasource="#session.dsn#">
	select E.Edescripcion from #sifinterfacesdb#..int_ICTS_SOIN I
	inner join Empresas E on I.Ecodigo = E.Ecodigo where E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
	value="#Session.Ecodigo#">
</cfquery>

<cfoutput>
<cfset LvarNavegacion = ""> 

<cfif Form.fltPeriodoIni NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodoIni=#Form.fltPeriodoIni#">
</cfif>

<cfif Form.fltPeriodoFin NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodoFin=#Form.fltPeriodoFin#">
</cfif>

<cfif Form.fltMesIni NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMesIni=#Form.fltMesIni#">
</cfif>

<cfif Form.fltMesFin NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMesFin=#Form.fltMesFin#">
</cfif>

<cfif Form.fltOperacion NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltOperacion=#Form.fltOperacion#">
</cfif>

<cfif Form.Contrato NEQ "">
	<cfset LvarNavegacion = LvarNavegacion & "&Contrato=#Form.Contrato#">
</cfif>

<cfif Form.fltTipoDoc NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltTipoDoc=#Form.fltTipoDoc#">
</cfif>

<cfif Form.fltMoneda NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMoneda=#Form.fltMoneda#">
</cfif>

	<form name="form1" method="post" action="">
	<table width="100%">
				<tr>
				<td></td>
				<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
				<tr>
				<td width="190"><strong>&nbsp;&nbsp;&nbsp;Periodo Inicial:</strong>
					<select name="fltPeriodoIni" tabindex="3">
						<cfloop query="rsPeriodo">
                    		<option value="#rsPeriodo.Periodo#" <cfif #rsAñoMes.Año# EQ "#rsPeriodo.Periodo#">selected</cfif>>#rsPeriodo.Periodo#</option>
               			</cfloop>
					</select>
				</td>
				<td width="190"><strong>&nbsp;&nbsp;Periodo Final:</strong>
					<select name="fltPeriodoFin" tabindex="3">
						<cfloop query="rsPeriodo">
                    		<option value="#rsPeriodo.Periodo#" <cfif #rsAñoMes.Año# EQ "#rsPeriodo.Periodo#">selected</cfif>>#rsPeriodo.Periodo#</option>
               			</cfloop>
					</select>
				</td>
				<td width="240"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tipo Documento: </strong>
						<select name="fltTipoDoc" tabindex="5"> 
		                <option value="-1" selected="selected">(Todos)</option>
						<option value="PRFC">FACT</option>
						<option value="PRNF">NOFACT</option>
                		</select>
            	</td>
				<td width="130"> <strong>&nbsp;Orden Comercial: </strong>
				<td>
				<!---<cfset ArrayTrREF=ArrayNew(1)>
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
				<cfset ArrayAppend(ArrayTrREF,rsOrden.Orden)>--->
				
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
				Tabla="#sifinterfacesdb#..ESIFLD_HFacturas_Venta E inner join #sifinterfacesdb#..SIFLD_HCosto_Venta V on V.Venta = E.Contrato inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) and  I.CodICTS = convert (varchar(10),V.Ecodigo) "
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
				</td>		
			</td>							
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td width="190"><strong>&nbsp;&nbsp;&nbsp;Mes Inicial: </strong>
						<select name="fltMesIni" tabindex="5">
							<cfloop query="rsMes">
                    		<option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>      
               				</cfloop>
                		</select>
            	</td>
				<td width="190"><strong>&nbsp;&nbsp;Mes Final: </strong>
						<select name="fltMesFin" tabindex="5">
							<cfloop query="rsMes">
                    		<option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>      
               				</cfloop>
                		</select>
            	</td>
				<td width="240"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moneda: </strong>
            			<select name="fltMoneda" tabindex="5">
						<option value="-1" selected="selected">(Todas)</option>	
						<cfloop query="rsMoneda">
                    		<option value="#rsMoneda.Miso4217#" <cfif isdefined("form.fltMoneda") and trim(form.fltMoneda) EQ trim(rsMoneda.Miso4217)>selected</cfif>>#rsMoneda.Mnombre#</option>
               			</cfloop>
					</select>
				</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td width="240">&nbsp;&nbsp;
					<input  type="checkbox" name="chkMovAd"  id="chkMovAd"
					<cfif isdefined("Form.chkMoAd") and Form.chkMovAd EQ 1>checked</cfif>
					onclick="if (this.checked){}" value="1"><strong>Solo Movimientos Adicionales</strong>
				</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
					<table width="50" align="center">
			   		<tr><td><cf_botones values="Seleccionar" names="Seleccionar"></td>
					<td><cf_botones values="Limpiar" names="Limpiar"></td>
					<td><cf_botones values="Consultar Reporte" names="Consultar"></td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>		
			<td colspan="8">
                <cfquery name="rsLista" datasource="#Session.DSN#">
                    select '' as Espacio, Mes as NMes, Periodo, case Mes when 1 then 'Enero' when 2 then 	                    'Febrero' when 3 then 'Marzo' when 4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7                    then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when    10 then 'Octubre' when 11 then                    'Noviembre' when 12 then 'Diciembre'end as Mes, Orden_Comercial, Clas_Venta, case Clas_Venta when 'PRFC' then 				                    'FACT' when 'PRNF' then 'NOFACT' end as Tipo_Documento, Moneda, convert(varchar, 	 		                    convert(money,sum(Imp_Ingreso)),1) as Ingreso_Documento,
                    convert(varchar,convert(money,sum(Imp_Ingreso_Actual)),1) as Ingreso_Actual, 			                    convert(varchar,convert(money,sum(Imp_Costo)),1) as Costo_Documento,
 					convert(varchar,convert(money,sum(Imp_Costo_Actual)),1) as Costo_Agregado
					from SaldosUtilidad 
					where 
					1=1
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					<cfif form.fltPeriodoIni neq -1 and form.fltPeriodoFin neq -1>
						and Periodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoIni#">  and
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoFin#">
					</cfif>
					<cfif form.fltMesIni neq -1 and form.fltMesFin neq -1>
						and Mes between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesIni#"> and
				        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesFin#">
					</cfif>					
					<cfif form.fltTipoDoc neq "-1">
				       	and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltTipoDoc)#">
				    </cfif>
					<cfif form.fltMoneda neq "-1">
				       	and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
				    </cfif>
					<cfif form.Contrato neq "">
				       	and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Contrato)#">
				    </cfif>
					<cfif isdefined("form.chkMovAd") and form.chkMovAd EQ 1>
						and Imp_Ingreso_Actual != 0  or Imp_Costo_Actual != 0
					</cfif>
					group by Periodo, Mes, Orden_Comercial, Ecodigo, Clas_Venta, Moneda
					order by Orden_Comercial, Periodo, NMes
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
			<cfinvokeargument name="cortes" value="Orden_Comercial"/>
			<cfinvokeargument name="desplegar"value="Espacio,Periodo,Mes,Tipo_Documento,Moneda,Ingreso_Documento,  Ingreso_Actual, Costo_Documento, Costo_Agregado"/>
			<cfinvokeargument name="etiquetas"value=" ,Periodo,Mes,Tipo Documento,Moneda,Ingreso Documento, Ingreso Agregado, Costo Documento, Costo Agregado"/>
			<cfinvokeargument name="formatos" value="S,S,S,V,V,V,S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,S,S,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center,center, center, center,center, left,left, left, left"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="ConsultaVtas-Costo-registro.cfm"/>   
            <cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="Periodo, NMes, Orden_Comercial, Clas_Venta, Moneda"/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
		</cfinvoke>

</cfoutput>

<script language="javascript" type="text/javascript">
	function funcLimpiar()
		{
			document.form1.fltPeriodoIni.value = '-1';
			document.form1.fltMesIni.value = '-1';
			document.form1.fltPeriodoFin.value = '-1';
			document.form1.fltMesFin.value = '-1';
			document.form1.fltTipoDoc.value = '-1';
		}
	function funcConsultar()
	{
		document.form1.action = "ConsultaVtas-Costo-exportacion.cfm";
	}
</script>


