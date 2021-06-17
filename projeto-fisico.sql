CREATE SCHEMA IF NOT EXISTS `covid` DEFAULT CHARACTER SET utf8 ;
USE `covid` ;

CREATE TABLE IF NOT EXISTS `covid`.`regioes` (
  `id` INT NOT NULL,
  `nome` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`estados` (
  `id` INT NOT NULL,
  `regiao_id` INT NOT NULL,
  `nome` VARCHAR(80) NOT NULL,
  `uf` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_estados_regioes_idx` (`regiao_id` ASC) VISIBLE,
  CONSTRAINT `fk_estados_regioes`
    FOREIGN KEY (`regiao_id`)
    REFERENCES `covid`.`regioes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`cidades` (
  `id` INT NOT NULL,
  `estado_id` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `numero_habitantes` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_cidades_estados_idx` (`estado_id` ASC) VISIBLE,
  CONSTRAINT `fk_cidades_estados`
    FOREIGN KEY (`estado_id`)
    REFERENCES `covid`.`estados` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`pacientes` (
  `id` INT NOT NULL,
  `cidade_natal_id` INT NOT NULL,
  `nome` VARCHAR(80) NOT NULL,
  `sobrenome` VARCHAR(150) NULL,
  `sexo` VARCHAR(45) NOT NULL,
  `data_nascimento` DATE NULL,
  `cpf` INT(11) UNSIGNED NULL,
  `rg` VARCHAR(25) NULL,
  `peso` FLOAT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pacientes_cidades_idx` (`cidade_natal_id` ASC) VISIBLE,
  CONSTRAINT `fk_pacientes_cidades`
    FOREIGN KEY (`cidade_natal_id`)
    REFERENCES `covid`.`cidades` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`comorbidades` (
  `id` INT NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `descricao` TINYTEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`paciente_comorbidade` (
  `comorbidade_id` INT NOT NULL,
  `paciente_id` INT NOT NULL,
  INDEX `fk_paciente_comorbidade_comorbidades_idx` (`comorbidade_id` ASC) VISIBLE,
  INDEX `fk_paciente_comorbidade_pacientes_idx` (`paciente_id` ASC) VISIBLE,
  CONSTRAINT `fk_paciente_comorbidade_comorbidades`
    FOREIGN KEY (`comorbidade_id`)
    REFERENCES `covid`.`comorbidades` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_paciente_comorbidade_pacientes`
    FOREIGN KEY (`paciente_id`)
    REFERENCES `covid`.`pacientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`paciente_enderecos` (
  `id` INT NOT NULL,
  `paciente_id` INT NOT NULL,
  `cidade_id` INT NOT NULL,
  `rua` VARCHAR(255) NOT NULL,
  `numero` VARCHAR(25) NOT NULL,
  `bairro` VARCHAR(150) NOT NULL,
  `complemento` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_paciente_enderecos_pacientes_idx` (`paciente_id` ASC) VISIBLE,
  INDEX `fk_paciente_enderecos_cidades_idx` (`cidade_id` ASC) VISIBLE,
  CONSTRAINT `fk_paciente_enderecos_pacientes`
    FOREIGN KEY (`paciente_id`)
    REFERENCES `covid`.`pacientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_paciente_enderecos_cidades`
    FOREIGN KEY (`cidade_id`)
    REFERENCES `covid`.`cidades` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`hospitais` (
  `id` INT NOT NULL,
  `cidade_id` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `rua` VARCHAR(255) NOT NULL,
  `numero` VARCHAR(25) NOT NULL,
  `bairro` VARCHAR(150) NOT NULL,
  `complemento` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hospitais_cidades_idx` (`cidade_id` ASC) VISIBLE,
  CONSTRAINT `fk_hospitais_cidades`
    FOREIGN KEY (`cidade_id`)
    REFERENCES `covid`.`cidades` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`paciente_hospitais` (
  `id` INT NOT NULL,
  `paciente_id` INT NOT NULL,
  `hospital_id` INT NOT NULL,
  `codigo_atendimento` VARCHAR(45) NOT NULL COMMENT 'Um codigo unico para identificar o atendimento',
  `status` VARCHAR(20) NOT NULL COMMENT 'Na coluna pode ser setado \"curado\" ou \"obito\"',
  `data_entrada` DATE NULL,
  `data_saida` DATE NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_paciente_estado_clinico_pacientes_idx` (`paciente_id` ASC) VISIBLE,
  INDEX `fk_paciente_hospitais_hospitais_idx` (`hospital_id` ASC) VISIBLE,
  UNIQUE INDEX `codigo_atendimento_UNIQUE` (`codigo_atendimento` ASC) VISIBLE,
  CONSTRAINT `fk_paciente_estado_clinico_pacientes`
    FOREIGN KEY (`paciente_id`)
    REFERENCES `covid`.`pacientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_paciente_hospitais_hospitais`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `covid`.`hospitais` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `covid`.`paciente_contatos` (
  `id` INT NOT NULL,
  `paciente_id` INT NOT NULL,
  `responsavel` VARCHAR(255) NULL,
  `email` VARCHAR(255) NULL,
  `telefone` VARCHAR(45) NULL,
  `descricao` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_paciente_contatos_pacientes_idx` (`paciente_id` ASC) VISIBLE,
  CONSTRAINT `fk_paciente_contatos_pacientes`
    FOREIGN KEY (`paciente_id`)
    REFERENCES `covid`.`pacientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;