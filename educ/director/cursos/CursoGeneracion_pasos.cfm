<cfset LvarPaso = 1>
<cfif isdefined("form.Ccodigo") and form.Ccodigo NEQ "">
	<cfset LvarPaso = 5>
<cfelseif isdefined("form.Mcodigo") and form.Mcodigo NEQ "">
	<cfset LvarPaso = 4>
<cfelseif isdefined("form.btnGenerar")>
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
		Escoja cada uno de los criterios para listar las materias a las que desea generarle cursos.<br>
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
    <td class="Title<cfif LvarPaso eq 2>On<cfelse>Off</cfif>"> Generación de Cursos </td>
  </tr>
  <cfif LvarPaso EQ 2>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Seleccione las materias a las que le desea generar cursos, marcando la cajita a la izquierda de cada una de ellas.  Luego indique la 'Cantidad' de cursos que desea generar para la materia seleccionada, y el 'Cupo' de alumnos en cada curso a generar.<br>
		Antes de presionar [Generar] asegúrese de que la 'Sede' sea el lugar correcto donde van a quedar asignados los cursos.
		Cuando todos los criterios estén seleccionados, presione [Listar Materias] o la tecla ENTER.
	</td>
  </tr>
  </cfif>
  <tr> 
    <td align="center"> <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="Opcion<cfif LvarPaso eq 3>On<cfelse>Off</cfif>">3</td>
        </tr>
      </table></td>
    <td class="Title<cfif LvarPaso eq 3>On<cfelse>Off</cfif>">Escoger la Materia a Trabajar</td>
  </tr>
  <cfif LvarPaso EQ 3 or LvarPaso EQ 2>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Durante la Generación de Cursos, se generaron tantos cursos vacíos (Inactivos) como se indicó en la columna 'Cantidad'.  La columna 'Cursos' indica la cantidad total de cursos existentes en la 'Sede' indicada, pero la columna 'Inactivos' se indica cuáles de esos cursos todavía no han sido terminados de definir.
		Una vez generados los cursos es necesario completar la información de Horario, Aula y Profesor, y así poder activar el curso dentro del sistema.<BR>
		Para Trabajar con los Cursos Inactivos, es decir, completar su información y activarlos,  presione el ícono <img src="/cfmx/educ/imagenes/iconos/folder_opn.gif"> en la Materia que se desea trabajar.
	</td>
  </tr>
  </cfif>
  <tr> 
    <td align="center"> <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="Opcion<cfif LvarPaso eq 4>On<cfelse>Off</cfif>">4</td>
        </tr>
      </table></td>
    <td class="Title<cfif LvarPaso eq 4>On<cfelse>Off</cfif>">Escoger el Curso a Completar</td>
  </tr>
  <cfif LvarPaso EQ 4>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Escoja el Curso al que se desea completar su información presionando el ícono <img src="/cfmx/educ/imagenes/iconos/leave_sel.gif">.
	</td>
  </tr>
  </cfif>

  <tr> 
    <td align="center"> <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="Opcion<cfif LvarPaso eq 5>On<cfelse>Off</cfif>">5</td>
        </tr>
      </table></td>
    <td class="Title<cfif LvarPaso eq 5>On<cfelse>Off</cfif>"> Completar Información de Curso </td>
  </tr>
  <cfif LvarPaso EQ 5>
  <tr> 
    <td>&nbsp;</td>
    <td class="Description">
		Cambie los Datos del Curso, su Horario, sus Asistentes y sus Parámetros de Comportamiento.
	</td>
  </tr>
  </cfif>
</table>
