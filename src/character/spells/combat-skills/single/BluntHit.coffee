
Spell = require "../../../base/Spell"

class BluntHit extends Spell
  name: "blunt hit"
  @element = BluntHit::element = Spell::Element.physical
  @tiers = BluntHit::tiers = [
    {name: "blunt hit", spellPower: 1, cost: 100, class: "Fighter", level: 13}
  ]

  cantAct: -> 1

  cantActMessages: -> "%player is currently stunned"

  calcDuration: -> super()+1

  calcDamage: ->
    minStat = (@caster.calc.stat 'str')/6
    maxStat = (@caster.calc.stat 'str')/4
    super() + @minMax minStat, maxStat

  cast: (player) ->
    damage = @calcDamage()
    message = "%casterName used %spellName on %targetName and dealt %damage HP damage!"
    @doDamageTo player, damage, message

  tick: (player) ->
    message = "%targetName is still suffering from %spellName."
    @broadcastBuffMessage player, message

  uncast: (player) ->
    message = "%targetName is no longer suffering from %spellName."
    @broadcast player, message

  constructor: (@game, @caster) ->
    super @game, @caster
    @bindings =
      doSpellCast: @cast
      doSpellUncast: @uncast
      "combat.self.turn.end": @tick

module.exports = exports = BluntHit
