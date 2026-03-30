<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Exportar" Default="Exportar" 
returnvariable="BTN_Exportar" xmlfile = "/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Filtrar" Default="Filtrar" 
returnvariable="BTN_Filtrar" xmlfile = "/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Limpiar" Default="Limpiar" 
returnvariable="BTN_Limpiar" xmlfile = "/sif/generales.xml"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Consulta de Pólizas Contabilizadas" 
returnvariable="LB_Titulo" xmlfile = "PolizaContable.xml"/>




<cfinclude template="Funciones.cfm">		
<cfset periodo="#get_val(30).Pvalor#">	   	
<cfset mes="#get_val(40).Pvalor#">

<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 27-2-2006.
		Motivo: Se concatena el periodo con el mes, se agrega la columna del monto, se ordenan las columnas de la 
		lista: Lote, póliza, descripción, período, fecha, monto.
	Modificado por Gustavo Fonseca H.
		Fecha: 28-2-2006.
		Motivo: Se agrega filtro de usuario en la lista.
	Modificado por Steve Vado Rodríguez.
		Fecha: 01-3-2006.
		Motivo: Se agregó la fecha de aplicación del asiento como una columna más.
	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
			rendimiento de la pantalla.
	
	Se modifica para que sostenga el filtro de cierre mensual y no ponga el cero en el campo de poliza.
--->
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfsetting enablecfoutputonly="no">

<cfif isdefined("url.txtref") and not isdefined("form.txtref")>
	<cfset form.txtref = url.txtref>
</cfif>

<cfif isdefined("url.intercomp") and not isdefined("form.intercomp")>
	<cfset form.intercomp = url.intercomp>
</cfif>

<cfif isdefined("url.txtdoc") and not isdefined("form.txtdoc")>
	<cfset form.txtdoc = url.txtdoc>
</cfif>

<cfif isdefined("url.CHKMesCierre") and not isdefined("form.CHKMesCierre")>
	<cfset form.CHKMesCierre = url.CHKMesCierre>
</cfif>
<cfif isdefined("url.Cconcepto") and not isdefined("form.Cconcepto")>
	<cfset form.Cconcepto = url.Cconcepto >	
</cfif>
<cfif isdefined("url.Eperiodo") and not isdefined("form.Eperiodo")>
	<cfset form.Eperiodo = url.Eperiodo >	
</cfif>
<cfif isdefined("url.Emes") and not isdefined("form.Emes")>
	<cfset form.Emes = url.Emes >
</cfif>

<cfif isdefined("url.Edocumento") and not isdefined("form.Edocumento")>
	<cfset form.Edocumento = url.Edocumento >	
</cfif>
<cfif isdefined("url.Edescripcion") and not isdefined("form.Edescripcion")>
	<cfset form.Edescripcion = url.Edescripcion >	
</cfif>
<cfif isdefined("url.fecha") and not isdefined("form.fecha")>
	<cfset form.fecha = url.fecha >	
</cfif>

<cfif isdefined("url.ECusuario") and not isdefined("form.ECusuario")>
	<cfset form.ECusuario = url.ECusuario>	
</cfif>
<cfif isdefined("url.fechaaplica") and not isdefined("form.fechaaplica")>
	<cfset form.fechaaplica = url.fechaaplica>	
</cfif>

<cfif isdefined("url.txtmonto") and not isdefined("form.txtmonto")>
	<cfset form.txtmonto = url.txtmonto>	
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo>	
</cfif>


<cfquery name="rsMonedas" datasource="#Session.DSN#">
    select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217
    from Monedas
    where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select distinct ECusuario, ECusuario as ECusuarioDESC
	  from HEContables
	  where Ecodigo = #Session.Ecodigo#
	<cfif isdefined("form.EPeriodo") and isdefined("form.EMes") and form.Eperiodo GT 0 and form.Emes GT 0>
       and Eperiodo = #form.EPeriodo#
       and Emes = #form.Emes#
    <cfelse>
       and Eperiodo = #Periodo#
       and Emes = #Mes#
    </cfif>
	order by ECusuario
</cfquery>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select Cconcepto, Cdescripcion 
    from ConceptoContableE 
	where Ecodigo = #Session.Ecodigo#
	order by Cconcepto
</cfquery>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = #Session.Ecodigo#
	order by Speriodo desc
</cfquery>

<cfset meses="#CMB_Enero#,#CMB_Febrero#,#CMB_Marzo#,#CMB_Abril#,#CMB_Mayo#,#CMB_Junio#,#CMB_Julio#,#CMB_Agosto#,#CMB_Setiembre#,#CMB_Octubre#,#CMB_Noviembre#,#CMB_Diciembre#">
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>


<cfset LvarTituloConsulta = "#LB_Titulo#">
<cfif isdefined("LvarAsientoRecursivo")>
	<cfset LvarTituloConsulta = "Consulta de Asientos Recurrentes">
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Poliza = t.Translate('LB_Poliza','P&oacute;liza')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripción')>
<cfset LB_Referencia = t.Translate('LB_Referencia','Ref')>
<cfset LB_Lote= t.Translate('LB_Lote','Lote')> 
<cfset LB_Documento=t.Translate('LB_Documento','Doc. Base')>
<cfset LB_Periodo=t.Translate('LB_Periodo','Periodo')>
<cfset LB_Fecha=t.Translate('LB_Fecha','Fecha')>
<cfset LB_AsientoAplicado=t.Translate('LB_AsientoAplicado','Aplic&oacute; Asiento')>
<cfset LB_Monto=t.Translate('LB_Monto','Monto')>



<cfset navegacion = "">
<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_dbfunction name="to_char" args="a.Eperiodo" returnvariable='LvarEperiodo'>
<cf_dbfunction name="to_char" args="a.Emes" returnvariable='LvarEmes'>
<cfset LvarFecha = "#LvarEperiodo# #_Cat# ' / ' #_Cat# #LvarEmes#">
<cfset LvarMaxRows = 900>
<cfset LvarTop = ''>
<cfset dbtype = Application.dsinfo[session.dsn].type>
<cfif dbtype eq 'sybase'>
	<cfset LvarTop = 'top #LvarMaxRows#'>
</cfif>

<cfquery name="rsLista" datasource="#Session.DSN#" maxrows="#LvarMaxRows#">
	select distinct	#LvarTop#
			a.IDcontable, 
			a.Edocumento, 
			<cf_dbfunction name='string_part' args="a.Edescripcion,1,60"> as Edescripcion,
			 #preservesinglequotes(LvarFecha)#  as fecha,  
			a.Efecha, 
			coalesce((
				select sum(Dlocal)
				from
				<cfif isdefined("Form.intercomp")>				
					HDContablesInt d
				<cfelse>
					HDContables d
				</cfif>
				where d.IDcontable = a.IDcontable
				  and d.Dmovimiento = 'D'
				  ), 0.00) as Monto,
			a.ECfechaaplica as fechaAplica,
			a.Cconcepto as Cconcepto,
            a.Edocbase,
            a.Ereferencia,
            case when a.ECtipo <> 20 then 'Normal' else 'Intercompañía' end as ECtipoe
	from HEContables a
		<cfif isdefined("Form.intercomp")>
			INNER JOIN EControlDocInt ei on ei.idcontableori=a.IDcontable
			INNER JOIN HDContablesInt hdi on hdi.IDcontable=a.IDcontable
			and ei.idcontableori=hdi.IDcontable
		</cfif>
	
    	<cfif isdefined("LvarAsientoRecursivo")>
        	inner join AsientosRecursivos b
            	on b.IDcontable = a.IDcontable
                and b.Ecodigo = a.Ecodigo
        </cfif>
		<cfif isdefined("Form.anulados") or isdefined("Form.txtmonto") or isdefined("Form.Mcodigo")>
			inner join HDContables hd on hd.IDcontable=a.IDcontable
		</cfif>
	where a.Ecodigo = #Session.Ecodigo#
	<cfif isdefined("Form.CHKMesCierre")>
		and a.ECtipo = 1
		<cfset navegacion = navegacion & "&CHKMesCierre=#form.CHKMesCierre#">
	<cfelse>
		and a.ECtipo <> 1
	</cfif>
	<cfif isdefined("Form.Cconcepto") and (Len(Trim(Form.Cconcepto)) NEQ 0) and (Form.Cconcepto NEQ "-1")>
		and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cconcepto#">
		<cfset navegacion = navegacion & "&Cconcepto=#form.Cconcepto#">
	</cfif>
	<cfif isdefined("Form.Eperiodo") and (Len(Trim(Form.Eperiodo)) NEQ 0) and (Form.Eperiodo NEQ "-1")>
		and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eperiodo#">
		<cfset navegacion = navegacion & "&Eperiodo=#form.Eperiodo#">
	<cfelseif  isdefined("Form.Eperiodo") and Len(Trim(Form.Eperiodo))>
		<cfset navegacion = navegacion & "&Eperiodo=#form.Eperiodo#">
	<cfelseif not isdefined("Form.Eperiodo")>
		and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodo#">
		<cfset navegacion = navegacion & "&Eperiodo=#periodo#">
	</cfif>
	<cfif isdefined("Form.Emes") and (Len(Trim(Form.Emes)) NEQ 0) and (Form.Emes NEQ "-1")>
		and a.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Emes#">
		<cfset navegacion = navegacion & "&Emes=#form.Emes#">
	<cfelseif isdefined("Form.Emes") and Len(Trim(Form.Emes)) NEQ 0>
		<cfset navegacion = navegacion & "&Emes=#form.Emes#">
	<cfelseif not isdefined("Form.Emes")>
		and a.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
		<cfset navegacion = navegacion & "&Emes=#mes#">
	</cfif>
	<cfif isdefined("Form.Edocumento") and (Len(Trim(Form.Edocumento)) NEQ 0)>
		and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Edocumento#">
		<cfset navegacion = navegacion & "&Edocumento=#Form.Edocumento#">
	</cfif>
	<cfif isdefined("Form.Edescripcion") and (Len(Trim(Form.Edescripcion)) NEQ 0)>
		and upper(a.Edescripcion) like '%#Ucase(Form.Edescripcion)#%'
		<cfset navegacion = navegacion & "&Edescripcion=#Form.Edescripcion#">
	</cfif>
	<cfif isdefined("Form.fecha") and (Len(Trim(Form.fecha)) NEQ 0)>			
		and a.Efecha >= #LSParseDateTime(Form.fecha)#
		<cfset navegacion = navegacion & "&fecha=#Form.fecha#">
	</cfif>
	<cfif isdefined("Form.fechaaplica") and (Len(Trim(Form.fechaaplica)) NEQ 0)>			
		and a.ECfechaaplica >= #LSParseDateTime(Form.fechaaplica)#
		and a.ECfechaaplica <= #dateadd('d', 1, LSParseDateTime(Form.fechaaplica))#
		<cfset navegacion = navegacion & "&fechaaplica=#Form.fechaaplica#">
	</cfif>
	<cfif isdefined("Form.ECusuario") and form.ECusuario NEQ 'Todos'>
		and a.ECusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ECusuario#">
		<cfset navegacion = navegacion & "&ECusuario=#form.ECusuario#">
	<cfelse>
		<cfset navegacion = navegacion & "&ECusuario=Todos">
	</cfif>
    
    <cfif isdefined("Form.txtref")>
    	and a.Ereferencia like '%#form.txtref#%'
		<cfset navegacion = navegacion & "&txtref=#form.txtref#">
    </cfif>
    <cfif isdefined("Form.txtdoc")>
    	and a.Edocbase like '%#form.txtdoc#%'
		<cfset navegacion = navegacion & "&txtref=#form.txtdoc#">
    </cfif>
    <cfif isdefined("Form.intercomp")>
    	and a.ECtipo = 20
		<cfset navegacion = navegacion & "&intercomp=#form.intercomp#">
    </cfif>
   	<cfif isdefined("Form.Mcodigo") and form.Mcodigo NEQ 'Todos'>
    	and hd.Mcodigo = #form.Mcodigo#
    </cfif>
   	<cfif isdefined("Form.txtmonto") and (Len(Trim(Form.txtmonto)) NEQ 0) and isnumeric(Form.txtmonto)>
    	and hd.Doriginal = <cfqueryparam cfsqltype="cf_sql_money" value="#form.txtmonto#">   
    </cfif>
    
	order by a.Cconcepto, a.Edocumento desc			
</cfquery>
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="#LB_Titulo#">
	<cfinclude template="../../portlets/pNavegacionCG.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
	    <cfset LvarActionForm = 'PolizaContable.cfm'>
		<cfif isdefined("LvarAsientoRecursivo")>
        	<cfset LvarActionForm = 'AsientosRecursivos.cfm'>
        </cfif>
		<form style="margin:0; " action="<cfoutput>#LvarActionForm#</cfoutput>" name="filtro" method="post" onsubmit="return sinbotones()">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
			<tr>
				<td colspan="6" align="center">
					<!---<cfoutput>--->
					<strong>** <cf_translate key=LB_Mensaje>La Lista tendr&aacute; un m&aacute;ximo de 900 registros.  Si no encuentra el asiento, por favor sea m&aacute;s específico en los filtros</cf_translate> **</strong>
					<br>
					<!---</cfoutput>--->
				</td>
			</tr>
			<tr> 
				<td ><strong><cf_translate key=LB_Lote>Lote</cf_translate></strong></td>
				<td align="left"><cfoutput><strong><cf_translate key=LB_Poliza>Poliza</cf_translate></strong></cfoutput></td>
				<td ><strong><cf_translate key=LB_Usuario>Usuario</cf_translate></strong></td>
				<td colspan="2" ><strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></strong></td>
			</tr>
			<tr>
				<td> 
					<select name="Cconcepto">
						<option value="-1" <cfif isdefined("Form.Cconcepto") AND Form.Cconcepto EQ "-1">selected</cfif>>(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>
						<cfoutput query="rsConceptos"> 
							<option value="#rsConceptos.Cconcepto#" <cfif isdefined("Form.Cconcepto") AND rsConceptos.Cconcepto EQ Form.Cconcepto>selected</cfif>>#rsConceptos.Cconcepto#-#rsConceptos.Cdescripcion#</option>
						</cfoutput> 
					</select>
				</td>
				<td align="left"> 
					<input name="Edocumento" type="text" id="Edocumento" size="12" maxlength="15" alt="#PolizaVal#" value="<cfif isdefined("Form.Edocumento")><cfoutput>#Form.Edocumento#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13'){ this.value=this.value; }}" >
				</td>
				<td>
				  	<cfoutput>
						<select name="ECusuario">
						<option value="Todos" <cfif isdefined("Form.ECusuario") AND Form.ECusuario EQ "Todos">selected</cfif>>(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>
						<cfloop query="rsUsuarios">
							<option value="#rsUsuarios.ECusuario#" <cfif isdefined("form.ECusuario") and form.ECusuario eq rsUsuarios.ECusuario>selected</cfif> >#rsUsuarios.ECusuarioDESC#</option>
						</cfloop>
						</select>
					</cfoutput>
				</td>
				<td colspan="2"> 
					<input name="Edescripcion" type="text" id="Edescripcion" size="50" maxlength="100" value="<cfif isdefined("Form.Edescripcion")><cfoutput>#Form.Edescripcion#</cfoutput></cfif>">
				</td>
				<!---<td nowrap style="vertical-align:middle ">
					<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Poliza_contable.htm">
				</td>--->
			</tr>
			<tr> 
				<td ><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong></td>
				<td ><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></strong></td>
				<td ><strong><cf_translate key=LB_Fecha>Fecha</cf_translate></strong></td>
				<td ><strong><cf_translate key=LB_Aplicacion>Aplicaci&oacute;n</cf_translate></strong></td>
			</tr>
			<tr>
				<td> 
					<select name="Emes" size="1">
						<option value="-1" <cfif isdefined("Form.Emes") AND Form.Emes EQ "-1">selected</cfif>>(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>
						<cfloop index="i" from="1" to="#ListLen(meses)#">
							<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("Form.Emes") AND Form.Emes EQ i>selected<cfelseif not isdefined("Form.Emes") AND mes EQ i>selected</cfif>> 
							<cfoutput>#ListGetAt(meses,i)#</cfoutput> </option>
						</cfloop>
					</select>
				</td>
				<td> 
					<select name="Eperiodo">
						<option value="-1" <cfif isdefined("Form.Eperiodo") AND Form.Eperiodo EQ "-1">selected</cfif>>(Todos)</option>
						<cfoutput query="rsPeriodos"> 
							<option value="#rsPeriodos.Eperiodo#" <cfif isdefined("Form.Eperiodo") AND rsPeriodos.Eperiodo EQ Form.Eperiodo>selected<cfelseif not isdefined("Form.Eperiodo") AND periodo EQ rsPeriodos.Eperiodo>selected</cfif>>#rsPeriodos.Eperiodo#</option>
						</cfoutput> 
					</select>
				</td>
				<td nowrap> 
					<cfset value = ''>
					<cfif isdefined("form.fecha") and len(trim(form.fecha)) gt 0>
						<cfset value = form.fecha >
					</cfif>
					<cf_sifcalendario form="filtro" value="#value#">
				</td>
				<td nowrap> 
					<cfset value = ''>
					<cfif isdefined("form.fechaaplica") and len(trim(form.fechaaplica)) gt 0>
						<cfset value = form.fechaaplica>
					</cfif>
					<cf_sifcalendario name="fechaaplica" form="filtro" value="#value#">
				</td>
			</tr>
            <tr>
            	<td><b><cf_translate key=LB_Referencia>Referencia</cf_translate>:</b></td>
                <td><b><cf_translate key=LB_Documento>Documento</cf_translate>:</b></td>
                <td><b><cf_translate key=LB_Moneda>Moneda</cf_translate>:</b></td>
                <td><b><cf_translate key=LB_Monto>Monto</cf_translate>:</b></td>
                <td></td>
            </tr>
             <tr>
            	<td><input type="text" name="txtref" id="txtref" value="<cfif isdefined("Form.txtref")><cfoutput>#Form.txtref#</cfoutput></cfif>"/></td>
                <td><input type="text" name="txtdoc" id="txtdoc" value="<cfif isdefined("Form.txtdoc")><cfoutput>#Form.txtdoc#</cfoutput></cfif>"/></td>
                <td><select name="Mcodigo" tabindex="10">
                	<option value="Todos" <cfif isdefined("Form.Mcodigo") AND Form.Mcodigo EQ "Todas">selected</cfif>>(<cf_translate key=LB_Todos>Todas</cf_translate>)</option>
                    <cfoutput query="rsMonedas">
                      <option value="#rsMonedas.Mcodigo#"
                        <cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
                            <cfif form.Mcodigo eq rsMonedas.Mcodigo>selected</cfif> 
                        </cfif> >#rsMonedas.Mnombre#</option>
                    </cfoutput>
                </select></td>
				<td><input type="numeric" name="txtmonto" id="txtmonto" value="<cfif isdefined("Form.txtmonto")><cfoutput>#Form.txtmonto#</cfoutput></cfif>"/></td>                
            </tr>
            
			<tr>
                <td><label for ="intercomp"><cf_translate key=LB_Intercompania>Intercompa&ntilde;&iacute;a</cf_translate>:<input type="checkbox" name="intercomp" id="intercomp" value="1" <cfif isdefined("Form.intercomp")><cfoutput> checked </cfoutput></cfif>/></label></td>
                <td colspan="2">
					<label for="anulados"><cf_translate key=LB_AsientosAnulados>Quitar Asientos Anulados</cf_translate>:<input type="checkbox" name="anulados" id="anulados" value="1" <cfif isdefined("Form.anulados")><cfoutput> checked </cfoutput></cfif>/></label>
				</td>
            
				<td nowrap>
					<input type="checkbox" id="CHKMesCierre" name="CHKMesCierre" value="1" tabindex="1" <cfif isdefined("form.CHKMesCierre")>checked</cfif>>
					<label for="CHKMesCierre"><cf_translate key=LB_CierreAnual>Cierre Anual</cf_translate></label>
				</td>
				<td colspan="5" align="right"><cfoutput>
					<input name="btnExportar" type="button" id="btnExporta2" value="#BTN_Exportar#" onClick="javascript:Exportar(this.form);">&nbsp;&nbsp; 
					<input name="btnFiltrar"  type="button" id="btnFiltrar2" value="#BTN_Filtrar#" onClick="javascript:filtrar(this.form);">&nbsp;&nbsp; 
					<input name="btnLimpiar"  type="button" id="btnLimpiar"  value="#BTN_Limpiar#" onClick="javascript:Limpiar(this.form);">
                    </cfoutput>
				</td>
			</tr>
		</table>
		</form>
		<cfset interc=0>
		<cfif isdefined("Form.intercomp")>
			<cfset interc=1>
		</cfif>
        <cfset LvarIrA = 'SQLPolizaConta.cfm?intercomp=#interc#'>
		<cfif isdefined("LvarAsientoRecursivo")>
        	<cfset LvarIrA = 'SQLPolizaConta.cfm?LvarAsientoRecursivo=#LvarAsientoRecursivo#&intercomp=#interc#'>
        </cfif>
		<cfflush interval="120">
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		 returnvariable="pLista">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Cconcepto, Edocumento, Edescripcion,Ereferencia,Edocbase, fecha, Efecha, fechaAplica, Monto"/>
			<cfinvokeargument name="etiquetas" value="#LB_Lote#,#LB_Poliza#,#LB_Descripcion#,#LB_Referencia#,#LB_Documento#,#LB_Periodo#,#LB_Fecha#,#LB_AsientoAplicado#,#LB_Monto#"/>
			<cfinvokeargument name="formatos" value="V,V,V,V,V,V,D,D,M"/>
			<cfinvokeargument name="align" value="right,right,left,left,left,left,center,right ,right"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="irA" value="#LvarIrA#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="MaxRows" value="100"/>
		</cfinvoke>	
	<cf_web_portlet_end>
<cf_templatefooter>


<cfset LvarExportar = 'PolizaContableExcel.cfm'>
<cfif isdefined("LvarAsientoRecursivo")>
	<cfset LvarExportar = 'PolizaContableExcel.cfm?LvarAsientoRecursivo=#LvarAsientoRecursivo#'>
</cfif>
<script language="JavaScript1.2">
	function Limpiar(f) {
		f.action="PolizaContable.cfm";
		f.Cconcepto.selectedIndex = 0;
		for (var i=0; i<f.Eperiodo.length; i++) {
			if (f.Eperiodo[i].value == '<cfoutput>#periodo#</cfoutput>') {
				f.Eperiodo.selectedIndex = i;
				break;
			}
		}
		f.Emes.selectedIndex = <cfoutput>#mes#</cfoutput>;
		f.Edocumento.value = "";
		f.Edescripcion.value = "";
		f.fecha.value = "";
		f.ECusuario.selectedIndex = "";
		f.txtref.value = "";
		f.txtdoc.value = "";
	}
	function Exportar(f) {
		f.action="<cfoutput>#LvarExportar#</cfoutput>";
		f.submit();
	}
	function filtrar(f) {
		
		f.action="<cfoutput>#LvarActionForm#</cfoutput>";
		f.submit();
	}
</script>
