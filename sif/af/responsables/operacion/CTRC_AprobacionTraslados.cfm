<cfset fnGeneraConsultas()>
<cf_templateheader title="Aprobacion de Traslados">
    <cfinclude template="/sif/portlets/pNavegacion.cfm">
    <cf_web_portlet_start titulo="Lista de Documento por Aprobar">
        <form action="CTRC_AprobacionTrasladosSQL.cfm"  method="post" name="form1">
		  	<input type="hidden" name="CPDEmsgrechazo">

            <table width="100%"  border="0">
                <cfoutput>
                <tr>
                    <td width="10%" align="left" nowrap class="fileLabel">Centro de Custodia</td>
                    <td width="90%">
                        <cfif RSCentros.recordcount gt 0>
                            <cfif not isdefined("form.CRCCid")>
                                <cfset form.CRCCid = RSCentros.value>
                            </cfif>
                            <cfif RSCentros.recordcount eq 1>
                                <input name="CRCCid" value="#RSCentros.value#" type="hidden">
                                #RSCentros.CRCCcodigo#-#RSCentros.description#
                            <cfelse>
                                <select name="CRCCid"
                                    onchange="javascript :document.form1.action='';document.form1.submit();"  >
                                <cfloop query="RSCentros">
                                    <option  
                                    <cfif isdefined("form.CRCCid") and len(trim(form.CRCCid)) and form.CRCCid eq RSCentros.value> selected</cfif> 
                                    value="#RSCentros.value#">#RSCentros.CRCCcodigo#-#RSCentros.description#</option>
                                </cfloop>
                                </select>
                            </cfif>
                        <cfelse>
                            <input name="CRCCid"  value="-1" type="hidden">
                            El usuario no tiene asignado ningún centro de custodia 
                        </cfif>						
                    </td>
                </tr>
                </cfoutput>
                <cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
                <tr>
                    <td colspan="2" align="justify">
                        <img src="/cfmx/sif/imagenes/findsmall.gif">&nbsp;Información Detallada
                    </td>
                </tr>
                <tr>
                <td colspan="2">&nbsp;</td>
                </tr>

                <tr>
                    <td colspan="2">
							<cfset filtro = "a.AFTRestado in(10,40) and  b.Ecodigo = #Session.Ecodigo# and  c.Usucodigo  = #Session.Usucodigo# ">
                       <cfif #form.CRCCid# NEQ -1>
                         	<cfset filtro = filtro & "and a.CRCCid = #form.CRCCid#">
						</cfif>
                        <cfinvoke component="sif.Componentes.PlistaControl" method="GetControl" returnvariable="ContList">
                            <cfinvokeargument name="SScodigo" value="SIF">
                            <cfinvokeargument name="SMcodigo" value="AF">
                            <cfinvokeargument name="SPcodigo" value="CTRAPRB">
                            <cfinvokeargument name="default"  value="25">
                        </cfinvoke>
                        <cfinvoke 
                        component="sif.Componentes.pListas"
                        method="pLista"
                        returnvariable="Lvar_Lista"
                        tabla="#tabla#"
                        columnas="#columnas#"
                        desplegar="tipotraslado, CRTipoDocumento, placaOri, CedOri, CFuncionalORI, Centros, CedDes, CFuncionalDES, info"
                        etiquetas="Tipo<br>Traslado, Tipo<br>Documento, Placa<br>Origen, Cédula<br>Origen, Ctr. Funcional<br>Origen, Ctr. Custodia<br>Origen, Cédula<br>Destino, Ctr. Funcional<br>Destino, &nbsp;"
                        formatos="I,I,S,S,I,I,S,I,U"
                        filtro="#filtro#"
                        incluyeform="false"
                        align="left,left,left,left,left,left,left,left,left"
                        checkboxes="S"
                        keys="AFTRid"
                        maxrows="#ContList.MaxRow#"
                        showlink="false"
                        filtrar_automatico="true"
                        filtrar_por="a.AFTRtipo, e.CRTDid, ACORI.Aplaca, EMPORI.DEidentificacion, CFOri.CFid, CCORI.CRCCid, EMPDES.DEidentificacion, CFDes.CFid, info"
                        mostrar_filtro="true"
                        rscrtipodocumento="#rsCRTipoDocumento#"
                        rstipotraslado="#rstipotraslado#"
                        rscfuncionalori="#rsCFuncionalORI#"
                        rscfuncionaldes="#rsCFuncionalDES#"
                        rscentros="#rsCentros#"
                        formname="form1"
                        ira=""
                        funcion="window.parent.verinfo"
                        fparams="AFTRid"
                        showemptylistmsg="true"
                        ajustar="N"
                        debug="N"
                        />							
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <cf_botones values="Aprobar,Rechazar"
                        names="Aprobar,Rechazar">
                    </td>
                </tr>  
                </cfif>
            </table>
        </form>
    <cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript">
	<cfif isdefined("form.Salida") and len(trim(form.Salida))>
		alert("<cfoutput>#form.Salida#</cfoutput>")		
	</cfif>
	function funcAprobar(){
		if(confirm('Esta seguro que desea aprobar los registros seleccionados ?')){
			return true;
		}
		else{
			return false;
		}
	}
	

	function funcRechazar(){
	var vReason = prompt('¿Está seguro(a) de que desea rechazar los registros seleccionados?, Debe digitar una razón de rechazo!','');
	if (vReason && vReason != ''){
		document.form1.CPDEmsgrechazo.value = vReason;
		document.location.href="CTRC_AprobacionTrasladoSQL.cfm?AnularError=true&CPDEmsgrechazo="+vReason;
		document.form1.nosubmit = true;
		return true;
		}
		if (vReason=='')
			alert('Debe digitar una razón de rechazo!');
		return false;
	}
	
	
	
	
	function verinfo(llave){
		var PARAM  = "CTRC_AprobacionTrasladosDet.cfm?AFTRid="+ llave
		open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=yes,width=500,height=450')
	}	
</script>

<cfoutput>
<cfif isDefined("Lvar_Lista") and len(trim(Lvar_Lista))>
	<script language="javascript1.2" type="text/javascript">	
		if (#Lvar_Lista# > 500) {
			alert('La consulta retorno mas de 500 registros. Favor detallar mas las condiciones del filtro para dar un mayor rendimiento.');
		}
	</script>
</cfif>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	document.form1.CRCCid.focus();
</script>

<cffunction name="fnGeneraConsultas" access="private" output="no">
    <cfquery datasource="#session.dsn#" name="RSCentros">
        select  
        	a.CRCCid as value, 
            a.CRCCcodigo, 
            a.CRCCdescripcion as description
        from  CRCentroCustodia a
              inner join CRCCUsuarios b
                on b.CRCCid  = a.CRCCid 
        where Ecodigo  = #session.Ecodigo#
        and  Usucodigo = #session.Usucodigo#
        union
        select -1 as value, ' ' as CRCCcodigo, 'Todos' as description from dual
        order by CRCCcodigo
    </cfquery>					
    
    <cfquery name="rsCRTipoDocumento" datasource="#Session.Dsn#">
        select b.CRTDid as value,<cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo) ,' - ',rtrim(b.CRTDdescripcion)"> as description, 0, b.CRTDcodigo
        from CRTipoDocumento b
        where b.Ecodigo = #Session.Ecodigo#
        union select -1 as value, '--Todos--' as description, -1, ' ' from dual
        order by 3,4
    </cfquery>
    
    <cfquery name="rstipotraslado" datasource="#Session.Dsn#">
        select -1 as value, '--Todos--' as description, -1, ' ' from dual
        union
        select 1 as value, 'Responsable' as description, 1, ' ' from dual
        union
        select 2 as value, 'Ctro. Custodia' as description, 2, ' ' from dual
        order by 3,4
    </cfquery>								
    
    <cfquery name="rsCFuncionalORI" datasource="#Session.DSn#">
        select distinct afr.CFid as value, <cf_dbfunction name="concat" args="rtrim(cf.CFcodigo) ,' - ',rtrim(cf.CFdescripcion)"> as description, 0, cf.CFcodigo
        from AFTResponsables aftr
    
            inner join AFResponsables afr
            on afr.AFRid = aftr.AFRid
    
            inner join CRCCUsuarios c
            on aftr.CRCCid 	 = c.CRCCid
    
            inner join CFuncional cf
            on cf.CFid = afr.CFid
        where  aftr.AFTRestado in(10,40)
          and afr.Ecodigo =  #Session.Ecodigo#
          and c.Usucodigo  = #Session.Usucodigo#
    
        union select -1 as value, '--Todos--' as description, -1, ' ' from dual
        order by 3,4
    </cfquery>
    
    <cfset LvarSinRH = true>
    
    <cfquery name="rsTiposNomina" datasource="#Session.dsn#">
        select count(1) as Cantidad
        from TiposNomina
        where Ecodigo = #Session.Ecodigo#
    </cfquery>
    
    <cfif rsTiposNomina.recordcount GT 0>
        <cfset LvarSinRH = false>
    </cfif>
    
    <cfif LvarSinRH>
        <cfquery name="rsCFuncionalDES" datasource="#Session.DSn#">
            select distinct 
                    cf.CFid as value, 
                    <cf_dbfunction name="concat" args="rtrim(cf.CFcodigo) ,' - ',rtrim(cf.CFdescripcion)"> as description, 
                    0, cf.CFcodigo
            from AFTResponsables aftr
                inner join AFResponsables afr
                on afr.AFRid = aftr.AFRid
        
                inner join CRCCUsuarios c
                on aftr.CRCCid 	 = c.CRCCid
        
                inner join DatosEmpleado de
                on de.DEid = aftr.DEid
            
                inner join EmpleadoCFuncional decf
                on decf.DEid = de.DEid
            
                inner join CFuncional cf
                on cf.CFid = decf.CFid
            
            where  aftr.AFTRestado in(10,40)
            and    afr.Ecodigo =  #Session.Ecodigo#
            and    c.Usucodigo  = #Session.Usucodigo#
            and    #now()# between decf.ECFdesde and decf.ECFhasta
        
            union 
                select -1, '--Todos--', -1, ' ' from dual
            order by 3,4
        </cfquery>
    <cfelse>
        <cfquery name="rsCFuncionalDES" datasource="#Session.DSn#">
            select distinct 
                    cf.CFid as value, 
                    <cf_dbfunction name="concat" args="rtrim(cf.CFcodigo) ,' - ',rtrim(cf.CFdescripcion)"> as description, 
                    0, cf.CFcodigo
            from AFTResponsables aftr
                inner join AFResponsables afr
                on afr.AFRid = aftr.AFRid
        
                inner join CRCCUsuarios c
                on aftr.CRCCid 	 = c.CRCCid
        
                inner join DatosEmpleado de
                on de.DEid = aftr.DEid
            
                inner join LineaTiempo LT
                        inner join RHPlazas RP
    
                            inner join CFuncional cf
                            on cf.CFid = RP.CFid
    
                        on RP.RHPid = LT.RHPid
                on LT.DEid = de.DEid
            
            where  aftr.AFTRestado in(10,40)
            and    afr.Ecodigo =  #Session.Ecodigo#
            and    c.Usucodigo  = #Session.Usucodigo#
            and    #now()# between LT.LTdesde and LT.LThasta
        
            union 
                select -1 as value, '--Todos--' as description, -1, ' ' from dual
            order by 3,4
        </cfquery>
    </cfif>
    
	<cf_dbfunction name="concat" args=" rtrim(e.CRTDcodigo) ,' - ',rtrim(e.CRTDdescripcion)" returnvariable="_CRTipoDocumento" >
    <cfset columnas = "
        a.AFTRid, a.AFRid,
        case a.AFTRtipo when 1 then 'Responsable' else 'Ctro. Custodia' end as  tipotraslado,
        #PreserveSingleQuotes(_CRTipoDocumento)# as CRTipoDocumento,
        ACORI.Aplaca as placaOri,
        EMPORI.DEidentificacion as CedOri,
        CFOri.CFdescripcion as CFuncionalORI,
        CCORI.CRCCcodigo as  Centros,
        b.AFRfini,
        b.CRDRdescripcion,
        (( select min(ACDES.Aplaca) from Activos ACDES where ACDES.Aid = a.Aid )) as placaDES,
        EMPDES.DEidentificacion as CedDes,
        CFDes.CFid as CFiddes, 
        CFDes.CFdescripcion as CFuncionalDES,
        CCDES.CRCCcodigo as  CentroCDES,
        '<img border=''0'' src=''/cfmx/sif/imagenes/findsmall.gif''>' as info"
    >
    
    <cfif LvarSinRH>
        <cfset tabla = "
            AFTResponsables a
                inner join AFResponsables b
                on b.AFRid   = a.AFRid
        
                inner join CRTipoDocumento e
                on  e.CRTDid  = b.CRTDid
        
                inner join Activos ACORI
                on b.Aid	=  ACORI.Aid
        
                left outer join CFuncional  CFOri
                on  CFOri.CFid = b.CFid
        
                inner join CRCentroCustodia CCORI
                on  CCORI.CRCCid  = b.CRCCid	
        
                inner join CRCCUsuarios c
                on a.CRCCid 	 = c.CRCCid
        
                inner join CRCentroCustodia CCDES
                on  a.CRCCid  = CCDES.CRCCid	
    
                left join DatosEmpleado EMPDES
                on EMPDES.DEid = a.DEid
				
				left join DatosEmpleado EMPORI
                on EMPORI.DEid = b.DEid
            
                left outer join EmpleadoCFuncional decf
                on decf.DEid = EMPDES.DEid 
                and #now()# between decf.ECFdesde and decf.ECFhasta
            
                left outer join CFuncional CFDes
                on CFDes.CFid = decf.CFid
        ">
    <cfelse>
        <cfset tabla = "
            AFTResponsables a
                inner join AFResponsables b
                on b.AFRid   = a.AFRid
        
                inner join CRTipoDocumento e
                on  e.CRTDid  = b.CRTDid
                and e.Ecodigo = b.Ecodigo
        
                inner join Activos ACORI
                on b.Aid	=  ACORI.Aid
        
                left outer join CFuncional  CFOri
                on  CFOri.CFid = b.CFid
        
                inner join CRCentroCustodia CCORI
                on  CCORI.CRCCid  = b.CRCCid	
        
                inner join CRCCUsuarios c
                on a.CRCCid 	 = c.CRCCid
        
                inner join CRCentroCustodia CCDES
                on  a.CRCCid  = CCDES.CRCCid	
    
                left join DatosEmpleado EMPDES
                on EMPDES.DEid = a.DEid
				
				left join DatosEmpleado EMPORI
                on EMPORI.DEid = b.DEid
            
                left outer join LineaTiempo LT
                on LT.DEid = EMPDES.DEid 
                and #now()# between LT.LTdesde and LT.LThasta
        
                left outer join RHPlazas RP
                on RP.RHPid = LT.RHPid
            
                left outer join CFuncional CFDes
                on CFDes.CFid = RP.CFid
        ">
    </cfif>
</cffunction>