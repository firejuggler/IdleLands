
Spell = require "../../../base/Spell"
SandwichBuff = require "./SandwichBuff.coffee"
Cookie = require "./Cookie.coffee"

class SandwichAlly extends Spell
  name: "Sandwich Ally"
  @element = SandwichAlly::element = Spell::Element.physical
  @tiers = SandwichAlly::tiers = [
    {name: "Sandwich Ally", spellPower: 1, cost: 200, class: "SandwichArtist", level: 10}
  ]

# Cure group level healing
  calcDamage: ->
    minStat = (@caster.calc.stat 'dex')/5
    maxStat = (@caster.calc.stat 'dex')/1.5
    super() + @minMax minStat, maxStat

  determineTargets: ->
    @targetSomeAllies size: @chance.integer({min: 1, max: 2})

  cast: (player) ->
    buff = @game.spellManager.modifySpell new SandwichBuff @game, @caster
    buff.affect player
    @name = buff.name
    damage = @calcDamage()
    message = "%casterName made %targetName a %spellName and healed %damage HP!"
    @doDamageTo player, -damage, message
    if player isnt @caster
      if @chance.integer({min: 1, max: 10}) < 10
        # Rate the sandwich; moderate chance of rating a 5, >50% chance of not doing so
        rating = @chance.integer({min: 1, max: 7})
        if rating < 5
          message = "%targetName rated the %spellName a #{rating}. %casterName confiscates his cookie!"
          @broadcast player, message
          cookie = @game.spellManager.modifySpell new Cookie @game, @caster
          cookie.affect @caster
        else
          message = "%targetName rated the %spellName a 5, and gets a free cookie!"
          @broadcast player, message
          cookie = @game.spellManager.modifySpell new Cookie @game, @caster
          cookie.affect player

  constructor: (@game, @caster) ->
    super @game, @caster
    @bindings =
      doSpellCast: @cast

module.exports = exports = SandwichAlly