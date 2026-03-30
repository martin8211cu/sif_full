
<cfif not isdefined("form.EOidorden") and isdefined ("url.EOidorden") and len(trim(url.EOidorden))>
    <cfset form.LLave = url.EOidorden>
    <cfset form.Modulo = 'EO'>
</cfif>


<cfif not isdefined("form.CTContid") and isdefined ("url.CTContid") and len(trim(url.CTContid))>
    <cfset form.LLave = url.CTContid>
    <cfset form.Modulo = 'Contratos'>
</cfif>

<cfif not isdefined("form.TESSPid") and isdefined ("url.TESSPid") and len(trim(url.TESSPid))>
    <cfset form.Modulo = 'SPM'>
    <cfset form.LLave = url.TESSPid>
	<!---Cuando sea por centro funcional cambia el modulo--->
	<cfif  isdefined ("url.LvarTipoDocumento") and url.LvarTipoDocumento eq 5 >
		<cfset form.Modulo = 'SPM_CF'>
	<cfelse>
		<cfset url.CFid = session.Tesoreria.CFid>
	</cfif>
</cfif>

<!--- Combo Categorias --->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion
	from ACategoria
	where Ecodigo =  #session.Ecodigo#
</cfquery>


    <cfquery name="rsDistribuciones" datasource="#session.DSN#">
        select CPDCid, <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
          from CPDistribucionCostos
         where Ecodigo=#session.Ecodigo#
           and CPDCactivo=1
       <!---    <cfif isdefined('form.CPDCid')and form.CPDCid NEQ "" and form.CPDCid NEQ 0>
           and CPDCid = #form.CPDCid#
           </cfif>--->
    </cfquery>


<form style="margin: 0" action="popUp-suficiencia.cfm" name="fsolicitud" id="fsolicitud" method="post">
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
         <td>
            <!---  Filtro  --->

            <cfif isdefined("url.CPDEnumeroDocumento") and len(url.CPDEnumeroDocumento) and not isdefined("form.CPDEnumeroDocumento")><cfset form.CPDEnumeroDocumento = url.CPDEnumeroDocumento></cfif>
            <cfif isdefined("url.CPDEdescripcion") and len(url.CPDEdescripcion) and not isdefined("form.CPDEdescripcion")><cfset form.CPDEdescripcion = url.CPDEdescripcion></cfif>
            <cfif isdefined("url.Ccodigo") and len(url.Ccodigo) and not isdefined("form.Ccodigo")><cfset form.Ccodigo = url.Ccodigo></cfif>
            <cfif isdefined("url.CFcodigo") and len(url.CFcodigo) and not isdefined("form.CFcodigo")><cfset form.CFcodigo = url.CFcodigo></cfif>


            <script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
            <cfoutput>
                <input type="hidden" value="#form.LLave#" 	name="LLave">
                <input type="hidden" value="#form.Modulo#" 	name="Modulo">
                <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                  <tr>
                    <td class="fileLabel" nowrap width="8%" align="right"><label for="CPDEnumeroDocumento">Provisi&oacute;n:</label></td>
                    <td nowrap width="31%">
                             <input type="text" name="CPDEnumeroDocumento" size="10" maxlength="20" value="<cfif isdefined('form.CPDEnumeroDocumento')>#form.CPDEnumeroDocumento#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>

					 <td class="fileLabel" align="right" nowrap>Centro Funcional:</td>
                     <cfif isdefined('form.CFid') and form.CFid NEQ "">
                      <td nowrap width="25%">
                      <cfquery name="rsCFuncional" datasource="#Session.DSN#">
							select  CFid, CFcodigo, CFdescripcion
							from CFuncional
							where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
						</cfquery>
						
						<cf_rhcfuncional form="fsolicitud" id="CFid" name="CFcodigo" desc="CFdescripcion" query="#rsCFuncional#" tabindex="1">
                         
                    </td>
                    <cfelse>
                     
                     
                    <td nowrap width="25%">
                          <cf_conlis
                            Campos="CFid,CFcodigo,CFdescripcion"
                            tabindex="6"
                            Desplegables="N,S,S"
                            Modificables="N,S,N"
                            Size="0,15,35"
                            Title="Lista de Centros Funcionales"
                            Tabla="CFuncional cf"
                            Columnas="CFid,CFcodigo,CFdescripcion"
                            Filtro="Ecodigo = #Session.Ecodigo# order by CFcodigo,CFdescripcion"
                            Desplegar="CFcodigo,CFdescripcion"
                            Etiquetas="C&oacute;digo,Descripci&oacute;n"
                            filtrar_por="CFcodigo,CFdescripcion"
                            Formatos="S,S"
                            form="fsolicitud"
                            Align="left,left"
                            Asignar="CFid,CFcodigo,CFdescripcion"
                            Asignarformatos="I,S,S"
                            />
                    </td>
                    </cfif>
					<td colspan="2">
                    </td>
                  </tr>
                  <tr>
                    <td class="fileLabel" nowrap width="9%" align="right">Descripci&oacute;n:</td>
                    <td nowrap width="25%"><input type="text" name="CPDEdescripcion" size="20" maxlength="100" value="<cfif isdefined('form.CPDEdescripcion')>#form.CPDEdescripcion#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>

	             	<td class="fileLabel" nowrap width="9%" align="right">Monto a Utilizar:</td>
                    <td width="27%" rowspan="1" align="left" valign="center">
                    	<cfparam name="form.montoTotal" default="">
                        <cfif isdefined("form.chkAgrupaSuficiencias")>  
                        <cf_monto name="montoTotal" id="montoTotal"  tabindex="-1" value="#form.montoTotal#" decimales="2" negativos="false" readonly = "true">
                        <cfelse>
                        <cf_monto name="montoTotal" id="montoTotal"  tabindex="-1" value="#form.montoTotal#" decimales="2" negativos="false">
                        </cfif>
					</td>
                    

                    <td>&nbsp;</td>
                    <td width="27%" rowspan="1" align="center" valign="center"><input type="submit" name="btnFiltro" value="Filtrar"></td>
                  </tr>
                  <tr>

					<td class="fileLabel" nowrap width="9%" align="right">Tipo Suficiencia:</td>
                  	<td width="27%" rowspan="1" align="left" valign="center">
					  	<select name="TipoItem" tabindex="1" value ="this.value"  onchange="this.form.submit()">
							<option value=""<cfif not isdefined("form.TipoItem") OR form.TipoItem EQ "">selected</cfif>>Todos</option></option>
							<option value="S"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "S")>selected</cfif>>Servicio</option>
							<option value="D"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "D")>selected</cfif>>Distribución</option>
                            <option value="F"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "F")>selected</cfif>>Activo Fijo</option>
                           <cfif form.Modulo NEQ "EO">
							<option value="C"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "C")>selected</cfif>>Clasificación Inv</option>
                           </cfif>
						</select>
                    </td>


					<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'S'>
	                    <td class="fileLabel" nowrap width="9%" align="right">Servicio:</td>
    	                <td nowrap width="25%">
        	                <cf_conlis
            	                Campos="Cid,Ccodigo,Cdescripcion"
                	            tabindex="6"
                    	        Desplegables="N,S,S"
                        	    Modificables="N,S,N"
	                            Size="0,15,35"
    	                        Title="Lista Conceptos de Servicios"
        	                    Tabla="Conceptos c"
            	                Columnas="Cid,Ccodigo,Cdescripcion"
                	            Filtro="Ecodigo = #Session.Ecodigo# order by Ccodigo,Cdescripcion"
                    	        Desplegar="Ccodigo,Cdescripcion"
                        	    Etiquetas="C&oacute;digo,Descripci&oacute;n"
                            	filtrar_por="Ccodigo,Cdescripcion"
	                            Formatos="S,S"
        	                    form="fsolicitud"
    	    	                Align="left,left"
                	            Asignar="Cid,Ccodigo,Cdescripcion"
                    	        Asignarformatos="I,S,S"
                        	    />
	                    </td>
					</cfif>
					<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'F'>
						<td class="fileLabel" nowrap width="9%" align="right">Categoría:</td>
					    <td align="left" id="tdCategoria">
                        <select tabindex="1" name="ACcodigo" >
						<option value="0" selected>Seleccionar Categoría </option>
                        	<cfloop query="rsCategorias">
								<option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
                            </cfloop>
						</select>
           			   </td>
					</cfif>

					<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'D'>
						<td class="fileLabel" nowrap width="9%" align="right">Distribución:</td>
						<td id="tdDistribucion">
						
                        
                        <select name="CPDCid" id="CPDCid" tabindex="1">
                        	<option value="0" selected>Seleccionar Distribución </option>
                        	<cfloop query="rsDistribuciones"> 
                            <option value="#rsDistribuciones.CPDCid#" 
                                <cfif isdefined('form.CPDCid') and form.CPDCid EQ rsDistribuciones.CPDCid>selected</cfif>>
                                    #rsDistribuciones.Descripcion#
                            </option>
                        	</cfloop> 
						</select>
						</td>
					</cfif>
  
				</tr>
				  <tr>
                	<td class="fileLabel" nowrap width="9%" align="right">NAP:</td>
                    <td width="27%" rowspan="1" align="left" valign="center">
                        <input type="text"
                        onFocus="javascript:this.value=qf(this); this.select();"
                        onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
                        name="NAP" size="10" maxlength="10" value="<cfif isdefined('form.NAP')>#form.NAP#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                  </tr>
                </table>
             <cfif form.Modulo  EQ 'Contratos'> 
                <tr>
                <td nowrap>
                   <input type="checkbox" name="chkAgrupaSuficiencias" id="chkAgrupaSuficiencias" value="" onclick="funcDesactivamontoTotal()"
                   onchange="this.form.submit()" <cfif isdefined("form.chkAgrupaSuficiencias")> checked </cfif>/>
                   
                   <strong>Agrupar Suficiencias</strong>
                </td>
                </tr>
            </cfif>
            </cfoutput>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
  
</table>

<cfif form.Modulo eq "EO">
	<!---Impuetos--->
    <cfquery name="rsImpuestos" datasource="#Session.DSN#">
        select Icodigo, Idescripcion
        from Impuestos
        where Ecodigo = #session.Ecodigo#
    </cfquery>

    <!---Impuesto--->
    <table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <cfoutput>
        <tr>
            <td width="50"><strong>Impuesto:</strong></td>
            <td>
              <div align="left">
                <select name="Icodigo" tabindex="4">
                  <option value="">No especificado</option>
                  <cfloop query="rsImpuestos">
                    <option value="#trim(rsImpuestos.Icodigo)#"> #rsImpuestos.Idescripcion#</option>
                  </cfloop>
                </select>
            </div></td>
        </tr>
		</cfoutput>
    </table>
</cfif>

<br />
	<!---Lista de Items--->
    <table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="subTitulo"><font size="2">Lista de Detalles</font></td>
        </tr>
    </table>


    <cfquery name="rsPeriodoAux" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 50
    </cfquery>
    <cfset LvarAuxAno = rsPeriodoAux.Pvalor>

    <cfquery name="rsMesAux" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 60
    </cfquery>
    
    <cfset LvarAuxMes = rsMesAux.Pvalor>
    <cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

	<cfset LvarMaxRows = 25>
    <cf_dbfunction name="op_concat" returnvariable="_Cat">
 <cfif form.Modulo eq "EO">

    <cfquery name="rsListaItems" datasource="#session.dsn#">
		select
        	'Provision: '#_Cat# <cf_dbfunction name="to_char" args="e.CPDEnumeroDocumento"> #_Cat# ' - '#_Cat#
        	e.CPDEdescripcion #_Cat# ' -  NAP=' #_Cat# <cf_dbfunction name="to_char" args="e.NAP"> as corte,
        	e.CPDEnumeroDocumento, e.CPDEdescripcion, e.NAP, d.CPCano, d.CPCmes, d.Cid, d.ACcodigo, d.CPDCid,
			<cfif not isdefined("form.TipoItem") or (isdefined("form.TipoItem") and trim(form.TipoItem) EQ '')>										  										               isnull(c.Ccodigo,ca.ACcodigodesc) as Ccodigo, isnull(c.Cdescripcion,ca.ACdescripcion) as Cdescripcion,
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'F')>
				ca.ACcodigo as Ccodigo, ca.ACdescripcion as Cdescripcion,
			<cfelseif (isdefined("form.TipoItem") and (trim(form.TipoItem) EQ 'S' or trim(form.TipoItem) EQ 'D'))>
				c.Ccodigo as Ccodigo,c.Cdescripcion as Cdescripcion,
			</cfif>
			d.CFid, cf.CFcodigo, CPDDsaldo, CPDDid, null as Ccodigoclas,
            #form.LLave# as llave, '#form.Modulo#' as modulo,e.CPDEid,
			'' as codllave
        from CPDocumentoE e
            inner join CPDocumentoD d
            	on d.CPDEid = e.CPDEid
			inner join CFuncional cf
            	on cf.CFid=d.CFid
			<cfif not isdefined("form.TipoItem") or (isdefined("form.TipoItem") and form.TipoItem EQ '')>
				left join Conceptos c
					on c.Cid=d.Cid
				left join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				left join AClasificacion cl
					on cl.ACid = d.ACid
				left join  CPDistribucionCostos dc
					on dc.CPDCid = d.CPDCid
					and CPDCactivo = 1
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'S') >
				inner join Conceptos c
					on c.Cid=d.Cid
					and d.CPDCid is null
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'D') >
				inner join Conceptos c
					on c.Cid=d.Cid
				inner join  CPDistribucionCostos dc
					on dc.CPDCid = d.CPDCid
					and CPDCactivo = 1 and d.CPDCid is not null
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'F') >
				inner join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				inner join AClasificacion cl
					on cl.ACid = d.ACid
			</cfif>
	   where e.Ecodigo=#session.Ecodigo#
       and e.CPDEtipoDocumento = 'R' and e.CPDEsuficiencia = 1
       and e.CPDEaplicado = 1
        and d.CPDDsaldo > 0
        and d.CPDDtipoItem <> 'C'
        and d.CPCano*100+d.CPCmes <= #rsPeriodoAux.Pvalor*100+rsMesAux.Pvalor#
        <cf_CPSegUsu_where Reservas="true" aliasCF="d" name="CFid" soloCFs="true">
        <cfif isdefined("url.CFid") and len(trim(url.CFid))>
            and d.CFid = #url.CFid#
        </cfif>
        <!---Valida que no este en una OC--->
         and (
              select count(1)
              	from ERemisionesFA ee
                   inner join DRemisionesFA dd
                          on dd.EOidorden = ee.EOidorden
              where ee.Ecodigo = e.Ecodigo
               and ee.EOestado between 0 and 9
               and dd.CPDDid = d.CPDDid
            ) = 0
        <!---Valida que no este en una SP--->
         and (
              select count(1)
                from TESsolicitudPago spe
                   inner join TESdetallePago spd
                          on spd.TESSPid = spe.TESSPid
              where spe.EcodigoOri = e.Ecodigo
               and spe.TESSPestado between 0 and 1
               and spd.CPDDid = d.CPDDid
            ) = 0
             <!---Valida que no este en un Contrato--->
            and (
              select count(1)
                from CTContrato conE
                   inner join CTDetContrato conD
                          on conD.CTContid = conE.CTContid
              where conE.Ecodigo = e.Ecodigo
               and conE.CTCestatus = 0
               and conD.CPDDid = d.CPDDid
            ) = 0
		<cfif isdefined("form.CPDEnumeroDocumento") and len(trim(form.CPDEnumeroDocumento))>
            and e.CPDEnumeroDocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPDEnumeroDocumento#">
			<cfset LvarMaxRows = 0>
        </cfif>

        <cfif isdefined("form.CPDEdescripcion") and len(trim(form.CPDEdescripcion)) >
            and upper(e.CPDEdescripcion) like  upper('%#form.CPDEdescripcion#%')
        </cfif>

        <cfif isdefined("form.Cid") and len(trim(form.Cid)) >
            and c.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
		</cfif>

        <cfif isdefined("form.CFcodigo") and len(trim(form.CFcodigo)) >
            and upper(cf.CFcodigo) like  upper('%#form.CFcodigo#%')
        </cfif>

       <cfif isdefined("form.NAP") and len(trim(form.NAP)) >
            and e.NAP= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NAP#">
			<cfset LvarMaxRows = 0>
       </cfif>

	   <cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) >
            and d.ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigo#">
			<cfset LvarMaxRows = 0>
       </cfif>

	   <cfif isdefined("form.CPDCid") and len(trim(form.CPDCid)) >
            and d.CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
			<cfset LvarMaxRows = 0>
       </cfif>
	</cfquery>
<cfelse>
	    <cfquery name="rsListaItems" datasource="#session.dsn#">
			select * from (
                select 'Provision: ' #_Cat# rtrim(convert (varchar(255), CPDEnumeroDocumento)) #_Cat# ' - ' + CPDEdescripcion + ' - NAP=' #_Cat#
	                rtrim(convert (varchar(255), NAP)) as corte,
	                isnull(cast(ca.ACcodigo as varchar),isnull(cast(c.Ccodigo as varchar),cast(ltrim(rtrim(Saldo.Ccodigoclas)) as varchar))) as Ccodigo,
	                isnull(ca.ACdescripcion,isnull(c.Cdescripcion,cls.Cdescripcion)) as Cdescripcion ,
	                #form.LLave# as llave,
	                '#form.Modulo#' as modulo,
	                Saldo.*,case when Saldo.CPDCid is null then cf.CFcodigo else null end CFcodigo,
                    cast(ltrim(rtrim(isnull(Saldo.CPDEnumeroDocumento,-1))) as varchar) #_Cat# '~'#_Cat#                    
					cast(isnull(Saldo.CPDDid,-1) as varchar) #_Cat# '~' #_Cat#
					cast(isnull(Saldo.CPCano,0) as varchar)#_Cat# '~' #_Cat#
					cast(isnull(Saldo.CPCmes,0) as varchar)#_Cat# '~' #_Cat#
					cast(isnull(Saldo.CPDCid,0) as varchar) #_Cat#'~' #_Cat#
					cast(isnull(Saldo.Cid,0) as varchar) #_Cat# '~'#_Cat#
					cast(isnull(cls.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
					cast(isnull(Saldo.CPDEid,-1) as varchar) codllave,
                    CPDEnumeroDocumento as NumSuficiencia
                from (
	                 select e.CPDEnumeroDocumento, e.NAP, e.CPDEdescripcion,
	                 	case when CPDCid is null then d.CFid else  e.CFidOrigen end CFidOrigen,
	                 	case when CPDCid is null then d.CPDDid else  -1 end CPDDid,
	                 	sum(d.CPDDsaldo) as CPDDsaldo, d.ACcodigo, d.ACid,e.CPDEid,
	                 	d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas
	                 from CPDocumentoE e
	                 inner join (
	                    select *
						from CPDocumentoD d
						 where  ( select count(1) from ERemisionesFA ee
	                            inner join DRemisionesFA dd on dd.EOidorden = ee.EOidorden
	                            where ee.Ecodigo = d.Ecodigo and ee.EOestado between 0 and 9 and d.CPDDid = dd.CPDDid ) = 0
	                    and ( select count(1) from TESsolicitudPago spe
	                            inner join TESdetallePago spd on spd.TESSPid = spe.TESSPid
	                            where spe.EcodigoOri = d.Ecodigo and spe.TESSPestado between 0 and 1 and d.CPDDid = spd.CPDDid ) = 0
	                     and ( select count(1) from CTContrato conE
	                            inner join CTDetContrato conD on conD.CTContid = conE.CTContid
	                        where conE.Ecodigo = d.Ecodigo and conE.CTCestatus = 0 and conD.CPDEid = d.CPDEid ) = 0 
                          and ( select count(1) from CTContrato conE
                                inner join CTDetContratoAgr conDAgr
                                on conDAgr.CTContid = conE.CTContid
	                        where conE.Ecodigo = d.Ecodigo and conE.CTCestatus = 0 and conDAgr.CPDEid = d.CPDEid ) = 0 
	                 ) d
	                 	on e.CPDEid = d.CPDEid
	                 where e.Ecodigo=#session.Ecodigo# and e.CPDEtipoDocumento = 'R' and e.CPDEsuficiencia = 1 and e.CPDEaplicado = 1
	                    and CPDEcontrato = 1
	                 group by e.CPDEnumeroDocumento, e.NAP,e.Ecodigo, e.CPDEdescripcion,
	                 	case when CPDCid is null then d.CFid else e.CFidOrigen end,
	                 	case when CPDCid is null then d.CPDDid else  -1 end,
	                    e.CPDEid, d.CPDEid, d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas, e.CPDEcontrato, d.ACcodigo,
	                    d.ACcodigo,d.ACid,e.CPDEtipoDocumento,e.CPDEsuficiencia,e.CPDEaplicado ,e.CPDEid
	                having sum(d.CPDDsaldo) > 0
				) Saldo
				left join CFuncional cf
                	on cf.CFid=Saldo.CFidOrigen
                left join Conceptos c
                	on c.Cid=Saldo.Cid
                left join ACategoria ca
					on ca.ACcodigo = Saldo.ACcodigo
                left join AClasificacion cl
                	on cl.ACid = Saldo.ACid
                left join  CPDistribucionCostos dc
                	on dc.CPDCid = Saldo.CPDCid
                	and CPDCactivo = 1
                left join Clasificaciones cls
                	on ltrim(rtrim(Saldo.Ccodigoclas)) = ltrim(rtrim(cls.Ccodigoclas))
				where 1=1
		<cfif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'S') >
						 and CPDDtipoItem  ='S'
						 and Saldo.Cid is not null
						 and Saldo.CPDCid is null
		<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'D') >
					 and (
	                     	(CPDDtipoItem  ='S'
						 		and Saldo.Cid is not null
						 		and Saldo.CPDCid is not null)
	                     	or(CPDDtipoItem  ='C'
						 		and Saldo.Ccodigoclas is not null
						 		and Saldo.CPDCid is not null)
                     )
		<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'C') >
					and CPDDtipoItem  ='C'
					and Saldo.Ccodigoclas is not null
					and Saldo.CPDCid is null
		<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'F') >
            and CPDDtipoItem  ='F'
        </cfif>

		<cfif isdefined("form.CPDEnumeroDocumento") and len(trim(form.CPDEnumeroDocumento))>
            and CPDEnumeroDocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPDEnumeroDocumento#">
			<cfset LvarMaxRows = 0>
        </cfif>

        <cfif isdefined("form.CPDEdescripcion") and len(trim(form.CPDEdescripcion)) >
            and upper(Saldo.CPDEdescripcion) like  upper('%#form.CPDEdescripcion#%')
        </cfif>

        <cfif isdefined("form.Cid") and len(trim(form.Cid)) >
            and c.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
		</cfif>

        <cfif isdefined("form.CFcodigo") and len(trim(form.CFcodigo)) >
            and upper(cf.CFcodigo) like  upper('%#form.CFcodigo#%')
        </cfif>

       <cfif isdefined("form.NAP") and len(trim(form.NAP)) >
            and Saldo.NAP= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NAP#">
			<cfset LvarMaxRows = 0>
       </cfif>

	   <cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) >
            and Saldo.ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigo#">
			<cfset LvarMaxRows = 0>
       </cfif>

	   <cfif isdefined("form.CPDCid") and len(trim(form.CPDCid)) >
            and Saldo.CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
			<cfset LvarMaxRows = 0>
       </cfif>
       
       <cfif isdefined("form.chkAgrupaSuficiencias")>
            and Saldo.CPCano*100+Saldo.CPCmes <= #LvarAuxAnoMes#
            and Saldo.CPCano = #rsPeriodoAux.Pvalor#
			<cfset LvarMaxRows = 0>
       </cfif>
       
			) as suf
		left join (
			select 	cast(isnull(ps.CPDEnumeroDocumento,-1) as varchar) + '~' +
					cast(isnull(d.CPDDid,-1) as varchar) + '~' +
					cast(isnull(d.CPCano,0) as varchar)+ '~' +
					cast(isnull(d.CPCmes,0) as varchar)+ '~' +
					cast(isnull(d.CPDCid,0) as varchar) +'~' +
					cast(isnull(d.Cid,0) as varchar) + '~' +
					cast(isnull(d.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
					cast(isnull(d.CPDEid,-1) as varchar) codllave
			from CTContrato c
			inner join CTDetContrato d
				on c.CTContid = d.CTContid
			inner join CPDocumentoE ps
				on d.CPDEid = ps.CPDEid
			where c.CTCestatus = 0
		) con
			on suf.codllave = con.codllave
		where con.codllave is null
        order by CPDEnumeroDocumento
	</cfquery>
</cfif>

        <cfif form.Modulo  EQ 'Contratos' and isdefined('rsListaItems.CPDEid')>
            <cfset form.CPDEid = #rsListaItems.CPDEid#>
            <cfset form.CPCmes = #rsListaItems.CPCmes#>
        </cfif>

    <table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <cfset navegacion = "">

                <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" value="#rsListaItems#">
                    <cfinvokeargument name="desplegar" value="CPCano, CPCmes, Ccodigo,Cdescripcion,CFcodigo,CPDDsaldo">
                    <cfinvokeargument name="etiquetas" value="a&ntilde;o,Mes, Servicio, Descripcion,Centro Funcional,Saldo">
                    <cfinvokeargument name="formatos" value="V,V,V,V,V,M">
                    <cfinvokeargument name="align" value="left,left,left,left,left,right">
                    <cfinvokeargument name="ajustar" value="S">
                <!---    <cfif isdefined ("rsListaItems") and rsListaItems.recordcount GT 0>
                        <cfinvokeargument name="botones" value="Agregar"/>
                    </cfif>--->
                    <cfinvokeargument name="showEmptyListMsg" value="true">
                    <cfinvokeargument name="irA" value="popUp-suficiencia-SQL.cfm">
                    <cfinvokeargument name="showlink" value="false">
                    <cfinvokeargument name="formName" value="fsolicitud">
                    <cfinvokeargument name="maxrows" value="#LvarMaxRows#"/>
                    <cfinvokeargument name="keys" value="CPDDid,llave,modulo,CPDEid,CPCmes,CPDCid,Cid,Ccodigoclas,codllave">
                    <cfinvokeargument name="fparams" value="CPDDid">
                    <cfinvokeargument name="checkboxes" value="S"/>
                    <cfinvokeargument name="checkall" value="S"/>
                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                    <cfinvokeargument name="usaAjax" value="true"/>
                    <cfinvokeargument name="conexion" value="#session.dsn#"/>
                    <cfinvokeargument name="Cortes" value="corte"/>
                    <cfinvokeargument name="incluyeForm" value="false"/>
                </cfinvoke>
            </td>
        </tr>
		<tr>
			<td align="center">
				<input type="hidden" value="" name="botonSel">
				<input class="btnGuardar" type="submit" tabindex="0" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcAgregar) return funcAgregar();" value="Agregar" name="btnAgregar">
            </td>
        </tr>
    </table>
</form>
	<script language='javascript' type='text/JavaScript' >
    <!--//
		function funcAgregar(){
			<cfoutput>
			if (document.fsolicitud.Modulo.value =='EO' && document.fsolicitud.Icodigo.value.length == 0 ){
			alert('Debe seleccionar un impuesto');
			return false;
			}


			document.fsolicitud.action="popUp-suficiencia-SQL.cfm?montoTotal=" + qf(document.getElementById("montoTotal").value) <cfif isdefined('fsolicitud.Icodigo') and len(trim(fsolicitud.Icodigo)) gt 0>+ "&Icodigo="+document.fsolicitud.Icodigo.value</cfif>;
			return true;
			</cfoutput>
        }
		function funcDesactivamontoTotal(){	
			if (document.fsolicitud.chkAgrupaSuficiencias.checked) {
				document.fsolicitud.montoTotal.disabled = true;
			}
			else{
				document.fsolicitud.montoTotal.disabled = false;
			}
        }
    //-->
    </script>

    <hr width="99%" align="center">

