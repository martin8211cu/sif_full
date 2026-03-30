<cfinvoke key="LB_CentroFunional" 		default="Centro Funcional"		returnvariable="LB_CentroFunional"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Contrato" 			default="Contrato"				returnvariable="LB_Contrato"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" 			default="Descripci&oacute;n"	returnvariable="LB_Descripcion"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MontoUtilizar" 		default="Monto a utilizar"		returnvariable="LB_MontoUtilizar"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TipoContrato" 		default="Tipo Contrato"			returnvariable="LB_TipoContrato"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Servicio" 			default="Servicio"				returnvariable="LB_Servicio"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Categoria" 			default="Categor&iacute;"		returnvariable="LB_Categoria"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NAP" 					default="NAP"					returnvariable="LB_NAP"						component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Impuesto" 			default="Impuesto"				returnvariable="LB_Impuesto"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDetalle" 		default="Lista Detalle"			returnvariable="LB_ListaDetalle"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SelecDistribucion" 	default="Seleccionar Distribuci&oacute;n"			returnvariable="LB_SelecDistribucion"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Distribucion" 		default="Distribuci&oacute;n"			returnvariable="LB_Distribucion"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ActFijo" 				default="Activo Fijo"			returnvariable="LB_ActFijo"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Clasificacion" 		default="Clasificaci&oacute;n"			returnvariable="LB_Clasificacion"			component="sif.Componentes.Translate" method="Translate"/>

<cfif not isdefined("form.IDdocumento") and isdefined ("url.IDdocumento") and len(trim(url.IDdocumento))>
    <cfset form.LLave = url.IDdocumento>
    <cfset form.Modulo = 'CxP'>
</cfif>
<cfquery name="rsECxP" datasource="#Session.DSN#">
	select Mcodigo from EDocumentosCxP where IDdocumento = #form.LLave#
</cfquery>

<cfif not isdefined("Form.TipoItem")>
    <cfset Form.TipoItem = 'S'>
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
</cfquery>

<!--- Tipos de Orden
<cfquery name="rsTipoOrden" datasource="#session.DSN#">
	select  '' as CMTOcodigo, 'Todos' as CMTOdescripcion
	union
	select rtrim(ltrim(CMTOcodigo)) as CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo=#Session.Ecodigo#
</cfquery>
--->
<form style="margin: 0" action="popUp-contrato.cfm?IDdocumento=<cfoutput>#form.llave#</cfoutput>" name="fcontrato" id="fcontrato" method="post">
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
                    <td class="fileLabel" nowrap width="8%" align="right"><label for="CPDEnumeroDocumento">#LB_Contrato#:</label></td>
                    <td nowrap width="31%">
                             <input type="text" name="CPDEnumeroDocumento" size="10" maxlength="20" value="<cfif isdefined('form.CPDEnumeroDocumento')>#form.CPDEnumeroDocumento#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>

					 <td class="fileLabel" align="right" nowrap>#LB_CentroFunional#:</td>
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
                            form="fcontrato"
                            Align="left,left"
                            Asignar="CFid,CFcodigo,CFdescripcion"
                            Asignarformatos="I,S,S"
                            />
                    </td>
					<td colspan="2">
					</td>
                  </tr>
                  <tr>
                    <td class="fileLabel" nowrap width="9%" align="right">#LB_Descripcion#:</td>
                    <td nowrap width="25%"><input type="text" name="CPDEdescripcion" size="20" maxlength="100" value="<cfif isdefined('form.CPDEdescripcion')>#form.CPDEdescripcion#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>

	             	<td class="fileLabel" nowrap width="9%" align="right">#LB_MontoUtilizar#:</td>
                    <td width="27%" rowspan="1" align="left" valign="center">
                    	<cfparam name="form.montoTotal" default="">
                        <cf_monto name="montoTotal" id="montoTotal" tabindex="-1" value="#form.montoTotal#" decimales="2" negativos="false">
					</td>

                    <td>&nbsp;</td>
                    <td width="27%" rowspan="1" align="center" valign="center"><input type="submit" name="btnFiltro" value="Filtrar"></td>
                  </tr>
                  <tr>

					<td class="fileLabel" nowrap width="9%" align="right">#LB_TipoContrato#:</td>
                  	<td width="27%" rowspan="1" align="left" valign="center">
					  	<select name="TipoItem" tabindex="1" value ="this.value"  onchange="this.form.submit()">
							<option value="S"<cfif (isdefined("Form.TipoItem") and (Form.TipoItem eq "S")) or not isdefined("Form.TipoItem") >selected</cfif>>#LB_Servicio#</option>
							<option value="D"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "D")>selected</cfif>>#LB_Distribucion#</option>
							<option value="F"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "F")>selected</cfif>>#LB_ActFijo#</option>
							<option value="C"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "C")>selected</cfif>>#LB_Clasificacion#</option>
						</select>
                    </td>


					<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'S'>
	                    <td class="fileLabel" nowrap width="9%" align="right">#LB_Servicio#:</td>
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
        	                    form="fcontrato"
    	    	                Align="left,left"
                	            Asignar="Cid,Ccodigo,Cdescripcion"
                    	        Asignarformatos="I,S,S"
                        	    />
	                    </td>
					</cfif>
					<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'F'>
						<td class="fileLabel" nowrap width="9%" align="right">#LB_Categoria#:</td>
					    <td align="left" id="tdCategoria">
                        <select tabindex="1" name="ACcodigo" >
						<option value="0" selected>Seleccionar Categoría </option>
                        	<cfloop query="rsCategorias">
								<option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
                            </cfloop>
						</select>
           			   </td>
					</cfif>

					<cfif isdefined("form.TipoItem") and (form.TipoItem EQ 'D' or form.TipoItem EQ 'DH')>
						<td class="fileLabel" nowrap width="9%" align="right">#LB_Distribucion#:</td>
						<td id="tdDistribucion">
						<select name="CPDCid">
						<option value="0" selected>#LB_SelecDistribucion# </option>
							<cfloop query="rsDistribuciones">
								<option value="#rsDistribuciones.CPDCid#"> #rsDistribuciones.Descripcion#</option>
							</cfloop>
						</select>
						</td>
					</cfif>
                  </tr>
				  <tr>
                	<td class="fileLabel" nowrap width="9%" align="right">#LB_NAP#:</td>
                    <td width="27%" rowspan="1" align="left" valign="center">
                        <input type="text"
                        onFocus="javascript:this.value=qf(this); this.select();"
                        onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
                        name="NAP" size="10" maxlength="10" value="<cfif isdefined('form.NAP')>#form.NAP#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                  </tr>
                </table>
            </cfoutput>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
</table>

<cfif form.Modulo eq "CxP">
	<!---Impuetos--->
    <cfquery name="rsImpuestos" datasource="#Session.DSN#">
        select Icodigo, Idescripcion
        from Impuestos
        where Ecodigo = #session.Ecodigo#
    </cfquery>

	<cfif (isdefined("form.TipoItem") and form.TipoItem NEQ 'C') or not isdefined("form.TipoItem") >
    <!---Impuesto--->
    <table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <cfoutput>
        <tr>
            <td width="50"><strong>#LB_Impuesto#:</strong></td>
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
</cfif>

<br />
<cfoutput>
	<!---Lista de Items--->
    <table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="subTitulo"><font size="2">#LB_ListaDetalle#</font></td>
        </tr>
    </table>
</cfoutput>


    <cfquery name="rsPeriodoAux" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 50
    </cfquery>

    <cfquery name="rsMesAux" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 60
    </cfquery>

	<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
	<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >

	<cfset LvarMaxRows = 25>
    <cf_dbfunction name="op_concat" returnvariable="_Cat">
    <cfquery name="rsListaItems" datasource="#session.dsn#">
		select 'Contrato: '#_Cat# <cf_dbfunction name="to_char" args="e.CTCnumContrato"> #_Cat# ' - '#_Cat#
        	e.CTCdescripcion #_Cat# ' -  NAP=' #_Cat# <cf_dbfunction name="to_char" args="e.NAP"> as corte,
        	e.CTCnumContrato, e.CTCdescripcion, e.NAP, d.CPCano, d.CPCmes, d.Cid, d.ACcodigo, d.CPDCid, d.CTDCconsecutivo,
			<cfif not isdefined("form.TipoItem") or (isdefined("form.TipoItem") and trim(form.TipoItem) EQ '')>										  										               isnull(c.Ccodigo,ca.ACcodigodesc) as Ccodigo, isnull(c.Cdescripcion,ca.ACdescripcion) as Cdescripcion,
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'C')>
				c.Ccodigo as Ccodigo,c.Cdescripcion as Cdescripcion,
				case
					when d.CPDCid is NULL then '#unchecked#'
					else '#checked#'
				end as Dist,
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'F')>
				ca.ACcodigo as Ccodigo, ca.ACdescripcion as Cdescripcion,
			<cfelseif (isdefined("form.TipoItem") and (trim(form.TipoItem) EQ 'S' or trim(form.TipoItem) EQ 'D'))>
				c.Ccodigo as Ccodigo,c.Cdescripcion as Cdescripcion,
			</cfif>
			d.CFid, cf.CFcodigo, isnull(d.CTDCmontoTotal,0) - isnull(d.CTDCmontoConsumido,0) CPDDsaldo, CTDCont CPDDid,
            #form.LLave# as llave, '#form.Modulo#' as modulo
        from CTContrato e
            inner join CTDetContrato d
            	on d.CTContid = e.CTContid
			left join CFuncional cf
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
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'C') >
				inner join Clasificaciones c
					on c.Ccodigo=d.Ccodigo
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'D') >
				inner join Conceptos c
					on c.Cid=d.Cid
				inner join  CPDistribucionCostos dc
					on dc.CPDCid = d.CPDCid
					and CPDCactivo = 1
					and d.CPDCid is not null
			<cfelseif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'F') >
				inner join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				inner join AClasificacion cl
					on cl.ACid = d.ACid
			</cfif>
	   where e.Ecodigo=#session.Ecodigo#
	   	and getdate() between e.CTfechaIniVig and e.CTfechaFinVig
	   	and e.CTMcodigo = #rsECxP.Mcodigo#
	   <cfif isdefined("form.TipoItem") and trim(form.TipoItem) NEQ ''>
           <cfif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'D') >
       		    and d.CMtipo in ('D','S')
            <cfelse>
               and d.CMtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoItem#">
       	    </cfif><!--- and e.CPDEsuficiencia = 1 --->
		<cfelse>
			and d.CMtipo = 'S'
		</cfif>
      	and e.CTCestatus = 1
        and isnull(d.CTDCmontoTotal,0) > isnull(d.CTDCmontoConsumido,0)
        and d.CPCano*100+d.CPCmes <= #rsPeriodoAux.Pvalor*100+rsMesAux.Pvalor#
        <cfif (isdefined("form.TipoItem") and trim(form.TipoItem) NEQ 'D') >
            <cf_CPSegUsu_where Reservas="true" aliasCF="d" name="CFid" soloCFs="true">
        </cfif>
        <cfif isdefined("url.CFid") and len(trim(url.CFid))>
            and d.CFid = #url.CFid#
        </cfif>
        <!---Valida que no este en una OC--->
         and (
              select count(1)
              	from EOrdenCM ee
                   inner join DOrdenCM dd
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
		<cfif isdefined("form.CPDEnumeroDocumento") and len(trim(form.CPDEnumeroDocumento))>
            and upper(e.CTCnumContrato) like upper('%#form.CPDEnumeroDocumento#%')
			<cfset LvarMaxRows = 0>
        </cfif>

        <cfif isdefined("form.CPDEdescripcion") and len(trim(form.CPDEdescripcion)) >
            and upper(e.CTCdescripcion) like  upper('%#form.CPDEdescripcion#%')
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

	   order by CTCnumContrato, CPDDid
	</cfquery>
<!--- <cf_dump var="#rsListaItems#"> --->
    <table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <cfset navegacion = "popUp-contrato.cfm">

				<cfset camposM = "CPCano, CPCmes, CTCnumContrato, CTDCconsecutivo,Ccodigo,Cdescripcion,CFcodigo,CPDDsaldo">
				<cfset etiquetasM = "A&ntilde;o,Mes, Contrato, Linea, Código, Descripcion,Centro Funcional,Saldo">
				<cfset formatosM = "V,V,V,V,V,V,V,M">
				<cfset alignM ="left,left,left,left,left,left,left,right">
				<cfif (isdefined("form.TipoItem") and trim(form.TipoItem) EQ 'C') >
					<cfset camposM = camposM & ",Dist">
					<cfset etiquetasM = etiquetasM & ",Distribuido">
					<cfset formatosM = formatosM & ",U">
					<cfset alignM = alignM & ",center">
				</cfif>

                 <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" value="#rsListaItems#">
                    <cfinvokeargument name="desplegar" value="#camposM#">
                    <cfinvokeargument name="etiquetas" value="#etiquetasM#">
                    <cfinvokeargument name="formatos" value="#formatosM#">
                    <cfinvokeargument name="align" value="#alignM#">
                    <cfinvokeargument name="ajustar" value="S">
                    <cfif (isdefined ("rsListaItems") and rsListaItems.recordcount GT 0 and (isdefined("form.TipoItem") and trim(form.TipoItem) NEQ 'C'))
						or not isdefined("form.TipoItem")>
                        <cfinvokeargument name="botones" value="Agregar"/>
                    </cfif>
                    <cfinvokeargument name="showEmptyListMsg" value="true">
                    <cfinvokeargument name="irA" value="popUp-contrato-SQL.cfm?IDdocumento=#form.llave#">
					<cfif (isdefined("form.TipoItem") and trim(form.TipoItem) NEQ 'C') or not isdefined("form.TipoItem")>
                    	<cfinvokeargument name="showlink" value="false">
					</cfif>
                    <cfinvokeargument name="formName" value="fcontrato">
                    <cfinvokeargument name="maxrows" value="#LvarMaxRows#"/>
                    <cfinvokeargument name="keys" value="CPDDid,llave,modulo,CTDCconsecutivo">
                    <cfinvokeargument name="fparams" value="CPDDid">
					<cfif (isdefined("form.TipoItem") and trim(form.TipoItem) NEQ 'C') or not isdefined("form.TipoItem")>
	                    <cfinvokeargument name="checkboxes" value="S"/>
	                    <cfinvokeargument name="checkall" value="S"/>
					</cfif>
                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                    <cfinvokeargument name="usaAjax" value="true"/>
                    <cfinvokeargument name="conexion" value="#session.dsn#"/>
                    <cfinvokeargument name="Cortes" value="corte"/>
                    <cfinvokeargument name="incluyeForm" value="false"/>
                </cfinvoke>

            </td>
        </tr>
    </table>
</form>
	<script language='javascript' type='text/JavaScript' >
    <!--//
		function funcAgregar(){
			<cfoutput>
			if (document.fcontrato.Icodigo.value.length == 0 ){
			alert('Debe seleccionar un impuesto');
			return false;
			}

			document.fcontrato.action="popUp-contrato-SQL.cfm?montoTotal=" + qf(document.getElementById("montoTotal").value) <cfif isdefined('fcontrato.Icodigo') and len(trim(fcontrato.Icodigo)) gt 0>+ "&Icodigo="+document.fcontrato.Icodigo.value</cfif>;
			return true;
			</cfoutput>
        }
    //-->
    </script>

    <hr width="99%" align="center">

