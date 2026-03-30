<cfset LvarPaso = 1>
<cfif isdefined("form.Ccodigo") and form.Ccodigo NEQ "">
	<cfset LvarPaso = 4>
<cfelseif isdefined("form.Mcodigo") and form.Mcodigo NEQ "">
	<cfset LvarPaso = 3>
<cfelseif isdefined("form.btnMaterias") AND listaMaterias.recordCount GT 0>
	<cfset LvarPaso = 2>
</cfif>
<table border="0" cellpadding="1" cellspacing="0">
  <tr> 
    <td align="center" width="45"> <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="Opcion<cfif LvarPaso eq 1>On<cfelse><cfif LvarPaso eq 1>On<cfelse>Off</cfif></cfif>">1</td>
        </tr>
      </table></td>
    <td class="Title<cfif LvarPaso eq 1>On<cfelse>Off</cfif>"> Criterios de Selecci&oacute;n </td>
  </tr>
  <cfif LvarPaso EQ 1>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Escoja cada uno de los criterios para listar las materias a las que desea darle mantenimiento a sus cursos.<br>
		Cuando todos los criterios estén seleccionados, presione [Listar Materias] o la tecla ENTER.
	</td>
  </tr>
  </cfif>
  <tr> 
    <td align="center"> <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="Opcion<cfif LvarPaso eq 2>On<cfelse>Off</cfif>">2</td>
        </tr>
      </table></td>
    <td class="Title<cfif LvarPaso eq 2>On<cfelse>Off</cfif>">Escoger Materia a Trabajar</td>
  </tr>
  <cfif LvarPaso EQ 2>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Para Trabajar con los Cursos Activos de una Materia,  presione el ícono <img src="../../imagenes/iconos/folder_opn.gif"> en la Materia que se desea trabajar.
	</td>
  </tr>
  </cfif>
  <tr> 
    <td align="center"> <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="Opcion<cfif LvarPaso eq 3>On<cfelse>Off</cfif>">3</td>
        </tr>
      </table></td>
    <td class="Title<cfif LvarPaso eq 3>On<cfelse>Off</cfif>">Escoger el Curso a Trabajar</td>
  </tr>
  <cfif LvarPaso EQ 3>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Escoja el Curso al que se desea actualizar su información presionando el ícono <img src="../../imagenes/iconos/leave_sel.gif">.
	</td>
  </tr>
  </cfif>

  <tr> 
    <td align="center"> <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="Opcion<cfif LvarPaso eq 4>On<cfelse>Off</cfif>">4</td>
        </tr>
      </table></td>
    <td class="Title<cfif LvarPaso eq 4>On<cfelse>Off</cfif>">Mantenimiento del Curso</td>
  </tr>
  <cfif LvarPaso EQ 4>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Actualice los Datos del Curso, su Horario, sus Asistentes y sus Parámetros de Comportamiento.
	</td>
  </tr>
  </cfif>
</table>
