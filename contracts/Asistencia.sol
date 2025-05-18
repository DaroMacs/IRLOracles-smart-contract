// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Asistencia is ERC20, AccessControl, ReentrancyGuard {

    bytes32 public constant PROFE_ROLE = keccak256("PROFE_ROLE");

    struct Session {
        bytes32 hash;
        uint256 deadline;
        bool activa;
    }

    mapping(uint256 => Session) public sesiones;
    mapping(address => bool) public alumnosPermitidos;
    uint256 private sessionCounter;
    mapping(uint256 => mapping(address => bool)) public haReclamado;

    event AlumnoRegistrado(address indexed alumno);
    event SessionCreada(uint256 indexed sessionId, bytes32 hash, uint256 deadline);
    event TokenReclamado(address indexed estudiante, uint256 cantidad, uint256 sessionId);
    constructor(
        string memory nombre,
        string memory simbolo,
        address professor
    ) ERC20(nombre, simbolo){
        require(professor != address(0));
        _grantRole(PROFE_ROLE, professor);

    }

    /**
     * @dev Permite al profesor registrar a un alumno.
     * @param _alumno Dirección del alumno a registrar.
     */
    function registrarAlumno(address _alumno) public onlyRole(PROFE_ROLE) {
        require(_alumno != address(0), "Direccion invalida");
        require(!alumnosPermitidos[_alumno], "Alumno ya registrado");

        alumnosPermitidos[_alumno] = true;

        emit AlumnoRegistrado(_alumno);
    }

    /**
     * @dev Permite al profesor crear una nueva sesión estableciendo un hash y una duración en días.
     * @param _hash El hash que representa la palabra secreta para la sesión.
     * @param _duracionEnDias Duración en días para la ventana de reclamación.
     */
    function crearSesion(bytes32 _hash, uint256 _duracionEnDias) public onlyRole(PROFE_ROLE) {
        require(_duracionEnDias > 0, "Duracion debe ser mayor que cero");

        uint256 deadline = block.timestamp + (_duracionEnDias * 1 days);

        uint256 sessionId = sessionCounter + 1;
        sessionCounter = sessionId;

        sesiones[sessionId] = Session({
             hash: _hash,
             deadline: deadline,
             activa: true
         });

        emit SessionCreada(sessionId, _hash, deadline);
    }

    /**
     * @dev Función para obtener detalles de una sesión específica.
     * @param _sessionId ID de la sesión a consultar.
     * @return hash El hash de la sesión.
     * @return deadline La fecha límite para reclamar tokens.
     * @return activa El estado de la sesión.
     */
     function obtenerSesion(uint256 _sessionId) public view returns (bytes32 hash, uint256 deadline, bool activa) {
         require(_sessionId > 0 && _sessionId <= sessionCounter, "Session ID invalido");
         Session memory sesion = sesiones[_sessionId];
         return (sesion.hash, sesion.deadline, sesion.activa);
     }

     /**
      * @dev Permite a un alumno registrado reclamar tokens proporcionando la palabra secreta para una sesión específica.
      * @param _sessionId ID de la sesión para la cual se reclama tokens.
      * @param _palabra La palabra secreta a ser hasheada y verificada.
      */
      function reclamarTokens(uint256 _sessionId, string memory _palabra) public nonReentrant {
          // Checks: Verificaciones
          require(alumnosPermitidos[msg.sender], "No estas autorizado para reclamar tokens");
          require(_sessionId > 0 && _sessionId <= sessionCounter, "Session ID invalido");
          Session memory sesion = sesiones[_sessionId];

          require(sesion.activa, "La sesion no esta activa");
          require(block.timestamp <= sesion.deadline, "La ventana de reclamacion ha cerrado");
          require(!haReclamado[_sessionId][msg.sender], "Ya has reclamado tokens para esta sesion");

          bytes32 hashCalculado = keccak256(abi.encodePacked(_palabra));

          require(hashCalculado == sesion.hash, "Palabra secreta incorrecta");

          // Effects: Actualizar el estado
          haReclamado[_sessionId][msg.sender] = true;


          // Interactions: Realizar interacciones externas o emitir tokens
          uint256 cantidad = 10 * (10 ** decimals());
          _mint(msg.sender, cantidad);

          emit TokenReclamado(msg.sender, cantidad, _sessionId);
      }


}
