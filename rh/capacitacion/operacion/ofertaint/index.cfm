<cfparam name="url.RHIAid" default="">
<cfparam name="url.RHGMid" default="">
<cfparam name="url.RHACid" default="">
<cfparam name="url.Mnombre" default="">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>

<cf_web_portlet_start titulo="Oferta Externa de Cursos">

	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cfquery datasource="#session.dsn#" name="lista">
		select i.RHIAid, i.RHIAnombre, m.Mcodigo, m.Msiglas, m.Mnombre,
				(select count(1) from RHProgramacionCursos pc
					where pc.RHIAid = i.RHIAid
					  and pc.Mcodigo = m.Mcodigo) +
				(select count(1) from RHCursos pc
					where pc.RHIAid = i.RHIAid
					  and pc.Mcodigo = m.Mcodigo) as dependencias,
				oa.RHOAactivar as existe
		from RHOfertaAcademica oa
			join RHInstitucionesA i
				on oa.RHIAid  = i.RHIAid
			join RHMateria m
				on  oa.Mcodigo = m.Mcodigo
			<cfif Len(url.RHGMid) and url.RHGMid neq 'null'>
			  join RHMateriasGrupo mg 
				on m.Mcodigo = mg.Mcodigo
				  and mg.RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHGMid#"> 
			</cfif>
			
		where i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif url.RHGMid eq 'null'>
		  and not exists (select 1 from RHMateriasGrupo mg 
				where m.Mcodigo = mg.Mcodigo
				  and mg.RHGMid is null )
		</cfif>
		<cfif url.RHACid eq 'null'>
		  and m.RHACid is null
		<cfelseif Len(url.RHACid)>
		  and m.RHACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHACid#">
		</cfif>
		<cfif Len(url.RHIAid)>
		  and i.RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHIAid#">
		</cfif>
		<cfif Len(url.Mnombre)>
		  and (upper( m.Mnombre ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.Mnombre)#%">
			or upper( m.Msiglas ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.Mnombre)#%"> )
		</cfif>
		order by i.RHIAnombre, m.Msiglas
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="inst">
		select RHIAid, RHIAnombre
		from RHInstitucionesA
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by RHIAnombre
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="area">
		select RHACid, RHACdescripcion
		from RHAreasCapacitacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by RHACdescripcion
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="grupo">
		select RHGMid, Descripcion
		from RHGrupoMaterias
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by Descripcion
	</cfquery>
	
	
      <table width="100%"  border="0" >
        <tr align="center">
          <td valign="top"><table width="750" border="0" style="border:1px solid black; background-color:#CCCCCC " cellpadding="2" cellspacing="0">
            <tr>
              <td valign="top" class="subtitulo">&nbsp;</td>
              <td style="font-size:16px" class="subtitulo">Oferta <strong>Interna</strong> de Cursos </td>
            </tr>
            <tr>
              <td rowspan="3" valign="top"><img src="info.gif" width="31" height="30"></td>
              <td>1. Seleccione la instituci&oacute;n y cursos que desea incluir o excluir de la oferta interna.</td>
            </tr>
            <tr>
              <td> 2. Presione el bot&oacute;n de mostrar para obtener la lista de cursos y su disponibilidad en la oferta interna. </td>
            </tr>
            <tr>
              <td>3. Marque las casillas correspondientes a los cursos que ofrecer&aacute; para cada instituci&oacute;n.</td>
            </tr>
          </table>
            </td>
        </tr>
        <tr>
          <td valign="top"><form action="." method="get" name="formfiltro" id="formfiltro">
            <table border="0">
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>Instituci&oacute;n</td>
                <td><select name="RHIAid" style="width:250px">
                    <option value="">-todas-</option>
                    <cfoutput query="inst">
                      <option value="#HTMLEditFormat(RHIAid)#" <cfif url.RHIAid is inst.RHIAid>selected</cfif>>#HTMLEditFormat(RHIAnombre)#</option>
                    </cfoutput>
                </select></td>
                <td>Grupo de Cursos </td>
                <td><select name="RHGMid" style="width:250px">
                  <option value="">-todos-</option>
                  <option value="null" <cfif url.RHGMid eq 'null'>selected</cfif>>-sin clasificar-</option>
                  <cfoutput query="grupo">
                    <option value="#HTMLEditFormat(RHGMid)#" <cfif url.RHGMid is grupo.RHGMid>selected</cfif>>#HTMLEditFormat(Descripcion)#</option>
                  </cfoutput>
                </select></td>
                <td>&nbsp;</td>
                <td><input name="mostrar" type="submit" id="mostrar" value="Mostrar"></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&Aacute;rea de capacitaci&oacute;n </td>
                <td><select name="RHACid" style="width:250px">
                    <option value="">-todas-</option>
                    <option value="null" <cfif url.RHACid eq 'null'>selected</cfif>>-sin clasificar-</option>
                    <cfoutput query="area">
                      <option value="#HTMLEditFormat(RHACid)#" <cfif url.RHACid is area.RHACid>selected</cfif>>#HTMLEditFormat(RHACdescripcion)#</option>
                    </cfoutput>
                </select></td>
                <td>Buscar Curso</td>
                <td><input type="text" name="Mnombre" value="<cfoutput>#HTMLEditFormat(url.Mnombre)#</cfoutput>" style="width:250px" onfocus="this.select()"></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
          </form></td>
        </tr>
        <tr>
          <td valign="top"><form action="ofertaint-apply.cfm" method="post" name="form1" id="form1"><table  width="100%" border="0" cellpadding="2" cellspacing="0">
            <tr>
              <td>&nbsp;</td>
              <td colspan="2">&nbsp;</td>
              <td>&nbsp;</td>
              <td colspan="2">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td class="tituloListas">&nbsp;</td>
              <td colspan="3" class="tituloListas">&nbsp;</td>
              <td colspan="2" align="center" class="tituloListas">Disponible</td>
              <td class="tituloListas">&nbsp;</td>
            </tr>
			<cfoutput query="lista" group="RHIAnombre">
            <tr>
              <td class="tituloListas">&nbsp;</td>
              <td colspan="3" align="left" class="tituloListas">#RHIAnombre#</td>
              <td align="right" class="tituloListas"><input name="ckIA" type="checkbox" id="ckIA" value="checkbox" onclick="checkall_click(this.form,this.checked,'ck#RHIAid#')">
			  </td>
              <td align="center" class="tituloListas">&nbsp;</td>
              <td class="tituloListas">&nbsp;</td>
            </tr>
			<cfoutput>
            <tr>
              <td>&nbsp;</td>
              <td><label for="c#RHIAid#x#Mcodigo#"></label></td>
              <td><label for="c#RHIAid#x#Mcodigo#">#HTMLEditFormat(Msiglas)#</label></td>
              <td><label for="c#RHIAid#x#Mcodigo#">#HTMLEditFormat(Mnombre)#</label></td>
              <td align="right">
			  <cfif dependencias>
				  <input type="checkbox" checked disabled>
			  <cfelse>
				  <input name="ck#RHIAid#x#Mcodigo#" type="checkbox" id="ck#RHIAid#x#Mcodigo#" value="1" <cfif existe>checked</cfif>>
				  <input name="val" type="hidden" value="#RHIAid#x#Mcodigo#">
				  <cfif existe>
				  <input name="ant" type="hidden" value="#RHIAid#x#Mcodigo#">
				  </cfif>
			  </cfif>
			  </td>
              <td align="left"><cfif dependencias>
                <img src="lock-gray.gif" width="12" height="14" border="0" alt="bloqueado">
              </cfif></td>
              <td>&nbsp;</td>
            </tr>
			</cfoutput></cfoutput>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td colspan="2">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td colspan="5" align="center"><input type="submit" name="Submit" value="Guardar"></td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td colspan="2">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>    <cfoutput>
		  <input type="hidden" name="RHIAid" value="#HTMLEditFormat(RHIAid)#">
		  <input type="hidden" name="RHACid" value="#HTMLEditFormat(RHACid)#">
		  <input type="hidden" name="RHGMid" value="#HTMLEditFormat(RHGMid)#">
		  <input type="hidden" name="Mnombre" value="#HTMLEditFormat(Mnombre)#">
		  </cfoutput>
          </form>      </td>
        </tr>
      </table>

<script type="text/javascript">
<!--
	function checkall_click(f,checked,prefix){
		for (var i=0; i < f.elements.length; i++){
			if (f.elements[i].name.substring(0,prefix.length) == prefix){
				f.elements[i].checked = checked;
			}
		}
	}
//-->
</script>
<cf_web_portlet_end>

<cf_templatefooter>