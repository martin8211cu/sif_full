<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2721" default="0" returnvariable="LvarAprobarConocimiento"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2722" default="0" returnvariable="LvarAprobarHabilidad"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Regresar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Guardar"
	Default="Guardar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Guardar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoConocimiento"
	Default="tipo conocimiento"
	returnvariable="LB_TipoConocimiento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoConocimiento"
	Default="tipo conocimiento"
	returnvariable="LB_TipoConocimiento"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha Desde"
	returnvariable="LB_FechaDesde"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dominio"
	xmlFile="OferenteExterno.xml"
	Default="Dominio"
	returnvariable="LB_Dominio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Justificacion"
	Default="Justificación"
	returnvariable="LB_Justificacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AnnoDesde"
	Default="Año Desde"
	xmlFile="OferenteExterno.xml"
	returnvariable="LB_AnnoDesde"/>    


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AnnoHasta"
	Default="Año Hasta"
	returnvariable="LB_AnnoHasta"/>    

    
<cf_translatedata name="get" tabla="RHHabilidades" col="a.RHHdescripcion" returnvariable="LvarRHHdescripcion">
<cf_translatedata name="get" tabla="RHConocimientos" col="a.RHCdescripcion" returnvariable="LvarRHCdescripcion">

<cfif ANOTA EQ "S">
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select  idcompetencia,tipo,RHCestado
		from RHCompetenciasEmpleado 
		where RHCEid  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEid#">
		and  Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("RHOid") and len(trim(RHOid))>
			and RHOid      =  <cfqueryparam cfsqltype="cf_sql_integer" value="#RHOid#">		
		<cfelse>	
			and DEid      =  <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">		
		</cfif>	
	</cfquery>

	<cfif rsDatos.Tipo eq 'H'><!----- por habilidades----->
		<cfquery name="rsCompetencias" datasource="#session.dsn#">
			select  a.RHHid as id, a.RHHcodigo as Competencia, #LvarRHHdescripcion# as descripcion,'H' as Tipo,
			coalesce(b.RHCinactivo,0) as RHCinactivo, coalesce(a.RHHinactivo,0) as RHHinactivo
			from  RHHabilidades a
			left outer join  RHConocimientos b
				on b.RHCid = a.RHHid
				and b.Ecodigo = a.Ecodigo 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHHid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.idcompetencia#">
		</cfquery>
	<cfelse><!----- por conocimientos----->
		<cfquery name="rsCompetencias" datasource="#session.dsn#">
			select  a.RHCid as id, a.RHCcodigo as Competencia, #LvarRHCdescripcion# as descripcion,'C' as Tipo,
			coalesce(b.RHCinactivo,0) as RHCinactivo , 0 as RHHinactivo
			from  RHConocimientos a
			left outer join  RHConocimientos b
				on b.RHCid = a.RHCid
				and b.Ecodigo = a.Ecodigo 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.idcompetencia#">
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="rsCompetencias" datasource="#session.dsn#">
		select  a.RHCid as id, a.RHCcodigo as Competencia, #LvarRHCdescripcion# as descripcion,'C' as Tipo,
		coalesce(b.RHCinactivo,0) as RHCinactivo, 0 as RHHinactivo
		from  RHConocimientos a
		left outer join  RHConocimientos b
			on b.RHCid = a.RHCid
			and b.Ecodigo = a.Ecodigo 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		union

		select  a.RHHid as id, a.RHHcodigo as Competencia, #LvarRHHdescripcion# as descripcion,'H' as Tipo,
		coalesce(b.RHCinactivo,0) as RHCinactivo, coalesce(a.RHHinactivo,0) as RHHinactivo
		from  RHHabilidades a
		left outer join  RHConocimientos b
			on b.RHCid = a.RHHid
			and b.Ecodigo = a.Ecodigo 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfquery name="rsCompetencias" dbtype="query">
	select  *
	from  rsCompetencias 
	where RHCinactivo <> 1  and RHHinactivo <> 1
	order by Tipo,descripcion
</cfquery>


<cfif isDefined("form.editacompetencia") and trim(form.editacompetencia) eq 1 and isdefined("form.RHCEid") and len(trim(form.RHCEid))>
	<cfquery name="rsCH" datasource="#session.dsn#">
		select DEid,Ecodigo,RHOid,idcompetencia,tipo,RHCEfdesde,RHCEfhasta,RHCEdominio,RHCEjustificacion,RHNid,RHCestado
        ,year(RHCEfdesde) as AnnoIni, year(RHCEfhasta) as AnnoFin
		from RHCompetenciasEmpleado
		where RHCEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
	</cfquery>
</cfif>

<cfset LvarUrlSubmit ='/cfmx/rh/capacitacion/expediente/SqlCompetenciasM.cfm'>
<cfif isdefined("Lvar_CompAuto") or isdefined("LvarAuto")>
	<cfset LvarUrlSubmit ='/cfmx/rh/autogestion/operacion/SqlCompetenciasMAuto.cfm'>
</cfif>
<form action="<cfoutput>#LvarUrlSubmit#</cfoutput>" method="post" name="Competencia1" onSubmit="return validarSubmit();">
<cfoutput>
	<table width="100%" border="0">
	  <cfif ANOTA EQ "S">
	  	<tr>
			<td  colspan="2" class="listaCorte" align="center"><strong><cf_translate key="LB_Anotaciones">Anotaciones</cf_translate></strong></td>
		</tr>
	  </cfif>
	  <tr>
		<td   align="LEFT" width="12%"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong></td>
		<td width="88%">
		    <cfif ANOTA EQ "S">
				<cfif rsDatos.tipo eq "H"><cf_translate key="LB_Habilidad">Habilidad</cf_translate><cfelse><cf_translate key="LB_Conocimiento">Conocimiento</cf_translate></cfif>
			<cfelse>
				<select  onchange="AgregarCombo();" name="Tipo" id="Tipo">
					<cfset habilidadesON=false> <!---20140908 ljimenez se cambia el valor de true para que no se puedan mostrar la opcion de poder registrar las habilidades desde autogestion--->
					<cfset conocimientosON=false>
					<cfloop query="rsCompetencias">
						<cfif rsCompetencias.tipo eq 'H' and not habilidadesON>
							<OPTION  VALUE="H" <cfif isdefined("rsCH") and rsCH.tipo eq 'H'>selected</cfif>  ><cf_translate key="CMB_Habilidades">Habilidades</cf_translate></OPTION>	
							<cfset habilidadesON=true>
						</cfif>
						<cfif rsCompetencias.tipo eq 'C' and not conocimientosON>
							<OPTION  VALUE="C" <cfif isdefined("rsCH") and rsCH.tipo eq 'C'>selected</cfif> ><cf_translate key="CMB_Conocimientos">Conocimientos</cf_translate></OPTION>
							<cfset conocimientosON=true>
						</cfif>	
					</cfloop>
				</select>
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td align="LEFT"><strong><cf_translate key="LB_Compentencia">Competencia</cf_translate></strong></td>
		<td>
			<cfif ANOTA EQ "S">
				#rsCompetencias.Competencia#-#rsCompetencias.descripcion#
			<cfelse>
				<select name="idcompetencia" id="idcompetencia"></select>
			</cfif>
		</td>
	  </tr>
	  <!---- nivel del conocimiento o habilidad---->
	  <cf_translatedata name="get" tabla="RHNiveles" col="RHNdescripcion" returnvariable="LvarRHNdescripcion">
	  <cfquery datasource="#session.dsn#" name="rsNiveles">
	  	 select RHNid,RHNcodigo,#LvarRHNdescripcion# as RHNdescripcion,RHNhabcono
	  	 from RHNiveles
	  	 where Ecodigo=#session.Ecodigo#
	  </cfquery>
	  <tr>
		<td align="LEFT"><strong><cf_translate key="LB_Nivel" xmlFile="/rh/generales.xml">Nivel</cf_translate></strong></td>
		<td>
			<cfif ANOTA EQ "S">
				<!----#rsCompetencias.Competencia#-#rsCompetencias.descripcion#---->
			<cfelse>
				<select name="idNivel" id="idNivel"></select>
			</cfif>
		</td>
	  </tr>
		<!---20140718 - ljimenez parametro para que solo captura del aNo en el registro de competencias--->
        <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
                ecodigo="#session.Ecodigo#" pvalor="2658" default="0" returnvariable="lvarSoloAnnoCompetencia"/>
                
	  <cfif lvarSoloAnnoCompetencia eq 1>
		  <tr>
            <td align="LEFT"><strong>#LB_AnnoDesde#</strong></td>
            <td colspan="2">
                <select name="AnnoIni" id="AnnoIni">
                    <option value=""></option>
                    <cfloop index="i" from="0" to="25">
                        <cfset vn_annoi = year(DateAdd("yyyy", -i, now()))>
                        <option value="#vn_annoi#" <cfif isdefined("rsCH") and #rsCH.AnnoIni# EQ #vn_annoi#> selected </cfif>> #vn_annoi# </option>
                    </cfloop>
                </select>
            </td>
          </tr>
        <!--- <tr>
            <td align="LEFT"><strong>#LB_AnnoHasta#</strong></td>
            <td colspan="2">
                <select name="AnnoFin">
                    <option value=""></option>
                    <cfloop index="i" from="0" to="25">
                        <cfset vn_annof = year(DateAdd("yyyy", -i, now()))>
                        <option value="#vn_annof#" <cfif isdefined("rsCH") and #rsCH.AnnoFin# EQ #vn_annof#> selected </cfif>> #vn_annof# </option>
                    </cfloop>
                </select>
            </td>
		</tr> --->	  
      <cfelse>
          <tr>
            <td align="LEFT"><strong>#LB_FechaDesde#</strong></td>
            <td>
                <cfset fechaini = LSDateFormat(Now(), 'dd/mm/yyyy')>
                <cfif isdefined("rsCH")> 
                    <cfset fechaini = LSDateFormat(rsCH.RHCEfdesde, 'dd/mm/yyyy')>
                </cfif>
                <cf_sifcalendario form="Competencia1" name="RHCEfdesde" value="#fechaini#">
            </td>
          </tr>
          <tr>
            <td align="LEFT"><strong>#LB_FechaHasta#</strong></td>
            <td>
                <cfset fechafin = ''>
                <cfif isdefined("rsCH") and LSDateFormat(rsCH.RHCEfhasta, 'dd/mm/yyyy') neq '01/01/6100'> 
                    <cfset fechafin = LSDateFormat(rsCH.RHCEfhasta, 'dd/mm/yyyy')>
                </cfif>
                <cf_sifcalendario form="Competencia1" name="RHCEfhasta" value="#fechafin#">
            </td>
          </tr>	  
      </cfif>

  	  <tr>
		<td align="LEFT"><strong><cf_translate key="LB_Dominio">Dominio</cf_translate></strong></td>
		<td>
			<cfset LvarDominio = '0'>
			<cfif isdefined("rsCH")> 
				<cfset LvarDominio = rsCH.RHCEdominio>
			</cfif>
			<cf_monto name="RHCEdominio" value="#LSNumberFormat(LvarDominio,'____.__')#" decimales="2" size="6"> &nbsp;%
		</td>
	  </tr>
	  <tr>
		<td align="LEFT" valign="top"><strong><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate></strong></td>
		<td align="right" valign="top"></td>
	  </tr>
<tr>
		<td colspan="2">
			<textarea name="RHCEjustificacion" rows="3" id="RHCEjustificacion" style="width: 100%"><cfif isdefined("rsCH") and len(trim(rsCH.RHCEjustificacion))><cfoutput>#trim(rsCH.RHCEjustificacion)#</cfoutput><cfelse><cfif ANOTA EQ "N"><cf_translate key="LB_ValorizacionInicial">Valorización inicial</cf_translate></cfif></cfif></textarea>
		</td>
	  </tr>
      
	  <tr>
		<td  align="center" colspan="2" class="formButtons">
			<input type="hidden" name="botonSel" value="">
			<input name="txtEnterSI" type="text" size="1" style="display:none" maxlength="1" readonly="true" class="cajasinbordeb">
			<cfif ANOTA EQ "N">
				<input type="submit" id="VERLIST" name="VERLIST" value="#BTN_Regresar#" onClick="javascript: deshabilitarValidacionCM(this);">		
			<cfelse>
				<input type="submit" name="NuevoC1" value="#BTN_Regresar#" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionCM) deshabilitarValidacionCM(this); ">
			</cfif>
			<input type="submit" name="AltaC1" value="#BTN_Guardar#" onClick="javascript: habilitarValidacionCM();">
			<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Eliminar" Default="Eliminar" XmlFile="/rh/generales.xml" returnvariable="BTN_Eliminar"/>
			<cfif isDefined("rsCH") and len(trim(form.RHCEid))>
				<input type="submit" name="BajaC1" value="#BTN_Eliminar#">	
			</cfif>
		</td>  
	  </tr>
      
 
    <cf_dbfunction name="op_concat" returnvariable="_cat">
    <cf_dbfunction name="to_char" args="RHCEid" returnvariable="Lvar_to_char_Iid">
    
    <cf_dbfunction name="to_char" args="DEid" returnvariable="Lvar_to_char_DEid">
    <cf_dbfunction name="to_char" args="tipo" returnvariable="Lvar_to_char_tipo">
    <cf_dbfunction name="to_char" args="idcompetencia" returnvariable="Lvar_to_char_idcompetencia">


<cfif isdefined('form.idcompetencia') and len(trim(form.idcompetencia))>      
    <cf_translatedata name="get" tabla="RHHabilidades" col="RHHdescripcion" returnvariable="LvarRHHdescripcion">
    <cfquery name="rsC" datasource="#session.dsn#">
        select a.DEid,RHCEid,
                tipo,
                idcompetencia,
                #LvarRHHdescripcion# as descripcion,
                RHCEdominio  ,
                RHHcodigo Cod
                <cfif isdefined("DEid") and len(trim(DEid))>
                    ,coalesce(d.RHNcodigo#_cat#' - '#_cat#d.RHNdescripcion,'---') as RHNcodigo
                <cfelse>
                	 ,'---' as RHNcodigo   
                </cfif>,
                a.RHNid,
                coalesce(rhn.RHNcodigo#_cat#' - '#_cat#rhn.RHNdescripcion,'---') as RHNcodigoUser
                <cfif  lvarSoloAnnoCompetencia>
                	,year(a.RHCEfdesde) as YDesde
                </cfif>
                	
				<cfif not lvarSoloAnnoCompetencia>
					,a.RHCEfdesde
					, a.RHCEfhasta	
				</cfif>
                
                ,'<a href="javascript: Eliminar(''' #_cat# #Lvar_to_char_Iid# #_cat# ''');"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>'  as borrar
		        ,'<a href="javascript: editarCompetencia(''' #_cat# #Lvar_to_char_Iid# #_cat# ''', ''' #_cat# #Lvar_to_char_DEid# #_cat# ''',''' #_cat# #Lvar_to_char_tipo# #_cat# ''',''' #_cat# #Lvar_to_char_idcompetencia# #_cat# ''');"><img src=''/cfmx/rh/imagenes/edit_o.gif'' border=''0''></a>'  as editar

        from RHCompetenciasEmpleado  a
            inner join RHHabilidades  b
                on a.idcompetencia = b.RHHid
                and a.Ecodigo = b.Ecodigo
            <cfif isdefined("DEid") and len(trim(DEid))>
                left outer join RHHabilidadesPuesto c
                    on b.RHHid = c.RHHid
                    and b.Ecodigo = c.Ecodigo
                    and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#puesto.RHPcodigo#">
                
                    left outer join RHNiveles d
                        on c.RHNid = d.RHNid
            </cfif>		
            left join RHNiveles rhn
                        on a.RHNid = rhn.RHNid
                
        <cfif isdefined("RHOid") and len(trim(RHOid))>
            where RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
        <cfelse>
            where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
        </cfif>
            and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and  tipo = 'H'
             and a.idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idcompetencia#"> 		
        order by #LvarRHHdescripcion#, a.RHCEfdesde
    </cfquery>
    
    <cfif isdefined('rsC') and rsc.RecordCount EQ 0>
        <cf_translatedata name="get" tabla="RHConocimientos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
        <cf_translatedata name="get" tabla="RHNiveles" col="e.RHNdescripcion" returnvariable="LvarRHNdescripcionE">
        <cf_translatedata name="get" tabla="RHNiveles" col="rhn.RHNdescripcion" returnvariable="LvarRHNdescripcion">
        	
        <cfquery name="rsC" datasource="#session.dsn#">
            select 	A.DEid,RHCEid ,tipo,idcompetencia, #LvarRHCdescripcion# as descripcion, RHCEdominio, RHCcodigo Cod
                    <cfif isdefined("DEid") and len(trim(DEid))>
                        , coalesce(e.RHNcodigo#_cat#' - '#_cat##LvarRHNdescripcionE#, '---') as RHNcodigo
                    <cfelse>    
                    	, '---' as RHNcodigo
                    </cfif>
                    , coalesce(rhn.RHNcodigo#_cat#' - '#_cat##LvarRHNdescripcion#,'---') as RHNcodigoUser
                    ,A.RHNid
                    
                    <cfif  lvarSoloAnnoCompetencia>
                		,year(A.RHCEfdesde) as YDesde
                	</cfif>
					<cfif not lvarSoloAnnoCompetencia>
						,A.RHCEfdesde
						, A.RHCEfhasta
					</cfif>
                    
            ,'<a href="javascript: Eliminar(''' #_cat# #Lvar_to_char_Iid# #_cat# ''');"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>'  as borrar
           ,'<a href="javascript: editarCompetencia(''' #_cat# #Lvar_to_char_Iid# #_cat# ''', ''' #_cat# #Lvar_to_char_DEid# #_cat# ''',''' #_cat# #Lvar_to_char_tipo# #_cat# ''',''' #_cat# #Lvar_to_char_idcompetencia# #_cat# ''');"><img src=''/cfmx/rh/imagenes/edit_o.gif'' border=''0''></a>'  as editar
                    
            from  RHCompetenciasEmpleado A
                inner join RHConocimientos C
                    on A.idcompetencia = C.RHCid
                    and A.Ecodigo = C.Ecodigo
                    and C.RHCinactivo = 0
            
                <cfif isdefined("DEid") and len(trim(DEid))>
                    left outer join RHConocimientosPuesto d
                        on C.RHCid = d.RHCid
                        and C.Ecodigo = d.Ecodigo
                        and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#puesto.RHPcodigo#">
                        
                        left outer join RHNiveles e
                            on d.RHNid = e.RHNid
                </cfif>
                left join RHNiveles rhn
                            on A.RHNid = rhn.RHNid
                <cfif isdefined("RHOid") and len(trim(RHOid))>
                    where RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
                <cfelse>
                    where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
                </cfif>
                and   A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and  tipo = 'C'		
                and A.idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idcompetencia#"> 
            order by #LvarRHCdescripcion#, A.RHCEfdesde
        </cfquery> 
    </cfif>

   


<tr>
    <td colspan="4">
        <cfif isdefined('rsC')>
        	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripción" returnvariable="LB_Descripcion" xmlFile="generales.xml"/> 
        	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Código" returnvariable="LB_Codigo" xmlFile="generales.xml"/>    
        	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="Fdesde" Default="Desde" returnvariable="Fdesde" xmlFile="generales.xml"/>    
        	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="Fhasta" Default="Hasta" returnvariable="Fhasta" xmlFile="generales.xml"/>

        	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NivelPuesto" Default="Nivel (Puesto)" returnvariable="LB_NivelPuesto" xmlFile="/rh/capacitacion/expedente/expediente.xml"/>
        	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NivelEmpleado" Default="Nivel (Empleado)" returnvariable="LB_NivelEmpleado" xmlFile="/rh/capacitacion/expedente/expediente.xml"/>
        	
        	<cfif lvarSoloAnnoCompetencia>
	        	<cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaEmpleadosDias">
	                <cfinvokeargument name="query" value="#rsC#"/>
	                <cfinvokeargument name="desplegar" value="Cod, descripcion,YDesde, RHNCodigo,RHNcodigoUser,editar,borrar  "/>
	                <cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #Fdesde#, #LB_NivelPuesto#,#LB_NivelEmpleado#"/>
	                <cfinvokeargument name="formatos" value="S,S,S,S,S,I,I"/>
	                <cfinvokeargument name="align" value="left, left, center, left,left, center, center"/>
	                <cfinvokeargument name="ajustar" value="N"/>
	                <cfinvokeargument name="checkboxes" value="N"/>
	                <cfinvokeargument name="irA" value="CompetenciaMant.cfm"/>
	                <cfinvokeargument name="keys" value="idcompetencia,RHCEid"/>
	                <cfinvokeargument name="showEmptyListMsg" value="true"/> 
	             </cfinvoke>	
        	<cfelse>
        		<cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaEmpleadosDias">
	                <cfinvokeargument name="query" value="#rsC#"/>
	                <cfinvokeargument name="desplegar" value="Cod, descripcion,RHCEfdesde,RHCEfhasta, RHNCodigo,RHNcodigoUser,editar,borrar  "/>
	                <cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #Fdesde#, #Fhasta#, #LB_NivelPuesto#,#LB_NivelEmpleado#"/>
	                <cfinvokeargument name="formatos" value="S,S,D,D,S,S,I,I"/>
	                <cfinvokeargument name="align" value="left, left, center, center, left, left, center, center"/>
	                <cfinvokeargument name="ajustar" value="N"/>
	                <cfinvokeargument name="checkboxes" value="N"/>
	                <cfinvokeargument name="irA" value="CompetenciaMant.cfm"/>
	                <cfinvokeargument name="keys" value="idcompetencia,RHCEid"/>
	                <cfinvokeargument name="showEmptyListMsg" value="true"/> 
	             </cfinvoke>

			</cfif>

            
        </cfif>
    </td>
</tr>
      
</cfif>      
	</table>
	<cfif ANOTA EQ "S">
		<input type="hidden" style="visibility:hidden" name="Tipo" id="Tipo" value="#rsDatos.Tipo#">
		<input type="hidden" style="visibility:hidden" name="idcompetencia" value="#rsDatos.idcompetencia#"  >
	</cfif>
	<cfif isdefined("RHOid") and len(trim(RHOid))>
		<input type="hidden" style="visibility:hidden" name="RHOid" value="#RHOid#">
	<cfelse>	
		<input type="hidden" style="visibility:hidden" name="DEID" id="DEID" value="#DEID#">
	</cfif>	
	<input type="hidden" style="visibility:hidden" name="MODOC1" value="#MODOC1#">
    
    <input type="hidden" style="visibility:hidden" name="MODODEl" value="">
    
	<input type="hidden" style="visibility:hidden" name="ANOTA" value="#ANOTA#">
	<input type="hidden" style="visibility:hidden" name="RHCEid" value="<cfif isdefined("form.RHCEid")>#form.RHCEid#</cfif>">
</cfoutput>	
</form>


<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//-->
</script>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objFormCM = new qForm("Competencia1");
	
	objFormCM.Tipo.required = true;
	objFormCM.Tipo.description="<cfoutput>#LB_TipoConocimiento#</cfoutput>";			
		
	objFormCM.idcompetencia.required= true;
	objFormCM.idcompetencia.description="<cfoutput>#LB_TipoConocimiento#</cfoutput>";	

	<cfif lvarSoloAnnoCompetencia EQ 0>
		objFormCM.RHCEfdesde.required= true;
		objFormCM.RHCEfdesde.description="<cfoutput>#LB_FechaDesde#</cfoutput>";	
		
		objFormCM.RHCEfhasta.required= true;
		objFormCM.RHCEfhasta.description="<cfoutput>#LB_FechaHasta#</cfoutput>";	
	<cfelse>
		objFormCM.AnnoIni.required= true;
		objFormCM.AnnoIni.description="<cfoutput>#LB_AnnoDesde#</cfoutput>"; 
	</cfif>

	objFormCM.RHCEdominio.required= true;
	objFormCM.RHCEdominio.description="#LB_Dominio#";	
	
	<cfif ANOTA EQ "S">
		objFormCM.RHCEjustificacion.required= true;
		objFormCM.RHCEjustificacion.description="#LB_Justificacion#";	
	</cfif>
 
 var jsArrayNiveles = new Array();
 	<cfoutput query="rsNiveles">
 			row = new Array();
 			row[0] = #rhnid#;
 			row[1] = '#trim(rhnhabcono)#';
 			row[2] = '#trim(rhncodigo)#';
 			row[3] = '#trim(rhndescripcion)#';
 		jsArrayNiveles[#currentrow-1#] = row; 
    </cfoutput> 
 
 	function AgregarCombo() {
		var combo = document.Competencia1.idcompetencia;
		var niveles = document.Competencia1.idNivel;
		var cont = 0;
		codigo = document.Competencia1.Tipo.value;
		combo.length=0;
		niveles.length=0;
		<cfoutput query="rsCompetencias">
			if ('#Trim(Tipo)#'==codigo)  
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsCompetencias.id#';
				combo.options[cont].text="#rsCompetencias.Competencia#-#rsCompetencias.descripcion#";
				cont++;
			};
		</cfoutput>
		cont = 0;
		niveles.length=0;
		for(i=0;i<jsArrayNiveles.length;i++){
			if(codigo==jsArrayNiveles[i][1]){
				niveles.length=cont+1;
				niveles.options[cont].value=jsArrayNiveles[i][0];	
				niveles.options[cont].text=jsArrayNiveles[i][2] +' - '+jsArrayNiveles[i][3];
				cont++;
			}
		}
	}

	function habilitarValidacionCM(){
		objFormCM.Tipo.required = true;
		objFormCM.idcompetencia.required= true;
		objFormCM.RHCEfdesde.required= true;
		objFormCM.RHCEdominio.required= true;
		<cfif MODOC1 NEQ "ALTA">
			objFormCM.RHCEjustificacion.required= true;
		</cfif>
	}
	
	function deshabilitarValidacionCM(e){
		objFormCM.Tipo.required = false;
		objFormCM.idcompetencia.required= false; 
		if(e.name.trim() == 'VERLIST')
			objFormCM.AnnoIni.required= false;	
		else
			objFormCM.RHCEfdesde.required= false;	
		
		objFormCM.RHCEdominio.required= false;
		<cfif ANOTA EQ "S">
			objFormCM.RHCEjustificacion.required= false;
		</cfif>
	}

	function setCombo(e,valor){
		var c = eval("document.Competencia1."+e);
		for(i=0;i<c.length;i++){
			if(c.options[i].value==valor){
				c.value=valor;
			}
		}
	}

	<cfif ANOTA EQ "N">
		AgregarCombo();
	</cfif>	

	<cfif isDefined("rsCH") and len(trim(rsCH.RHNid))>
		setCombo('idNivel',<cfoutput>#rsCH.RHNid#</cfoutput>)
	</cfif>
	<cfif isDefined("rsCH") and len(trim(rsCH.idcompetencia))>
		setCombo('idcompetencia',<cfoutput>#rsCH.idcompetencia#</cfoutput>)
	</cfif>

	function Eliminar(id){
		<cfif LvarAprobarConocimiento or LvarAprobarHabilidad>
			if(!validarPorAjax(id,2)){// chequea en eliminacion
				return false;
			}
		</cfif>
		document.Competencia1.MODODEl.value='DEL';
		document.Competencia1.RHCEid.value=id;
		document.Competencia1.submit();
	}

	function validarPorAjax(id,estado){
		//estado 1: guardar, 2:eliminar
		var tipo = $("#Tipo").val();
		var nivel = $("#idNivel").val();
		var competencia = $("#idcompetencia").val();
		var errs='';

		if(objFormCM.RHCEdominio.required){
			<cfif lvarSoloAnnoCompetencia EQ 0>
				var anno = $("#RHCEfdesde").val();
				if(anno==''){
					alert("<cfoutput>#LB_FechaDesde#</cfoutput> <cf_translate key="LB_EsRequerido" xmlFile="generales.xml">es requerido</cf_translate>");
					return false;
				}
			<cfelse>
				var anno = $("#AnnoIni").val();
				if(anno==''){
					alert("<cfoutput>#LB_AnnoDesde#</cfoutput> <cf_translate key="LB_EsRequerido" xmlFile="generales.xml">es requerido</cf_translate>");
					return false;
				}
			</cfif>

			<cfif isdefined("RHOid") and len(trim(RHOid))>
				var RHOid = <cfoutput>#RHOid#</cfoutput>;
			<cfelse>
				var DEid = $("#DEID").val();
			</cfif>
			 
			$.ajax({
		        type: "GET",
		        url: '<cfoutput>#LvarUrlSubmit#</cfoutput>',
		        data:{
		        	checkOperation:estado,
		        	RHCEid:id,
		        	tipo:tipo,
		        	nivel:nivel,
		        	competencia:competencia,
		        	anno:anno,
		        	<cfif isdefined("RHOid") and len(trim(RHOid))>
		        		RHOid:RHOid
		        	<cfelse>
		        		DEid:DEid
		        	</cfif>
		        },
		        async: false,
		        success : function(data) {
		            errs += data;
		        }
		    }); 
		}   
		 
	    if(errs !=''){
	    	alert(errs);	
	    	return false;
	    }
	    else{
	    	return true;
	    }
	}

	function validarSubmit(){
		<cfif LvarAprobarConocimiento or LvarAprobarHabilidad>
			if(!validarPorAjax(0,1)){// chequea en guardado
				return false;
			}
		</cfif>
		return true;
	}
	
//-->
</script>
